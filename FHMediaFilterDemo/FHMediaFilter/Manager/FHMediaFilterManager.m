//
//  FHMediaFilterManager.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaFilterManager.h"

#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVGIF89A2MvidResourceLoader.h"
#import "AVOfflineComposition.h"
#import "AVFileUtil.h"
#import "AVAssetWriterConvertFromMaxvid.h"

#import "FHMediaComponent.h"

#import "NSMutableDictionary+FHMediaFilterExtension.h"

@interface FHAnimatorView() {
    //重复播放标记
    BOOL _repeat;
    //相关联的media的指针拷贝
    AVAnimatorMedia *_mediaCopy;
}
@end

@implementation FHAnimatorView

- (instancetype)initWithVideo:(FHMediaComponentVideo *)video frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //生成媒体文件
        AVAnimatorMedia *media = [AVAnimatorMedia aVAnimatorMedia];
        //分类合成资源
        if ([video.alphaVideoName hasSuffix:@"gif"]) {
            AVGIF89A2MvidResourceLoader *resLoader = [AVGIF89A2MvidResourceLoader aVGIF89A2MvidResourceLoader];
            resLoader.movieFilename = video.rgbVideoName;
            resLoader.outPath = [AVFileUtil getTmpDirPath:video.clipSource];
            resLoader.alwaysGenerateAdler = TRUE;
            resLoader.serialLoading = TRUE;
            //关联
            media.resourceLoader = resLoader;
        }else {
            AVAssetJoinAlphaResourceLoader *resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
            resLoader.movieRGBFilename = video.rgbVideoName;
            resLoader.movieAlphaFilename = video.alphaVideoName;
            resLoader.outPath = [AVFileUtil getTmpDirPath:video.clipSource];
            resLoader.alwaysGenerateAdler = TRUE;
            resLoader.serialLoading = TRUE;
            //关联
            media.resourceLoader = resLoader;
        }
        media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
        _mediaCopy = media;
        //监听播放结束的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnimatorFinished:) name:AVAnimatorDidStopNotification object:nil];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    //只有被加载到superView后，才可以关联媒体文件。
    [self attachMedia:_mediaCopy];
    
}

- (void)startAnimateWithRepeat:(BOOL)repeat {
    _repeat = repeat;
    [_mediaCopy startAnimator];
}

- (void)handleAnimatorFinished:(NSNotification *)notification {
    //结束关联
    [_mediaCopy stopAnimator];
    [self attachMedia:nil];
    if (_repeat) {
        //重新播放
        [self attachMedia:_mediaCopy];
        [_mediaCopy startAnimator];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

@interface FHMediaFilterManager()

@property (nonatomic, strong, readwrite) NSMutableArray<FHMediaComponent*> *components;

/**
 组件合成器
 */
@property (nonatomic, strong) AVOfflineComposition *composition;

/**
 文件转换器
 */
@property (nonatomic, strong) AVAssetWriterConvertFromMaxvid *converter;

@property (nonatomic, strong) dispatch_queue_t joinAlphaQueue;

@end

#pragma mark - KeyNames
static NSString *const kKeyAbout = @"ABOUT";
static NSString *const kKeySource = @"Source";
static NSString *const kKeyDestination = @"Destination";
static NSString *const kKeyCompDurationSeconds = @"CompDurationSeconds";
static NSString *const kKeyCompFramesPerSecond = @"CompFramesPerSecond";
static NSString *const kKeyCompWidth = @"CompWidth";
static NSString *const kKeyCompHeight = @"CompHeight";
static NSString *const kKeyCompScale = @"CompScale";
static NSString *const kKeyFont = @"Font";
static NSString *const kKeyFontSize = @"FontSize";
static NSString *const kKeyFontColor = @"FontColor";
static NSString *const kKeyHighQualityInterpolation = @"HighQualityInterpolation";
static NSString *const kkeyCompClips = @"CompClips";

#pragma mark - ErrorDomain
static NSString *const kErrorDomain = @"FHVideoFilterManager Compose Error";

@implementation FHMediaFilterManager

#pragma mark - Lazy Init 
- (NSMutableArray<FHMediaComponent *> *)components {
    if (_components == nil) {
        _components = [[NSMutableArray alloc] init];
    }
    return _components;
}

#pragma mark - Component
-(void)addComponent:(FHMediaComponent *)component {
    if (component == nil) {
        return;
    }
    [self.components addObject:component];
}

#pragma mark - Public Method
- (void)startComposeAndOutput {
    NSMutableArray *videoComponent = [[NSMutableArray alloc] init];
    //将背景视频转换为mvid
    for (FHMediaComponent *component in self.components) {
        if ([component isKindOfClass:[FHMediaComponentVideo class]]){
            [videoComponent addObject:component];
        }
    }
    self.joinAlphaQueue = dispatch_queue_create("my.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    for (FHMediaComponentVideo *video in videoComponent) {
        AVAssetJoinAlphaResourceLoader *resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
        resLoader.movieRGBFilename = video.rgbVideoName;
        resLoader.movieAlphaFilename = video.alphaVideoName;
#if defined(HAS_LIB_COMPRESSION_API)
        resLoader.compressed = YES;
#endif // HAS_LIB_COMPRESSION_API
        resLoader.outPath = [AVFileUtil getTmpDirPath:[NSString stringWithFormat:@"%@",video.clipSource]];
        resLoader.alwaysGenerateAdler = TRUE;
        resLoader.serialLoading = TRUE;
        //同步转换多视频
        [resLoader loadWithGroup:self.joinAlphaQueue];
    }
    dispatch_barrier_async(self.joinAlphaQueue, ^(){
        //开始合成
        [self compose];
    });
}

- (void)compose {
    AVOfflineComposition *comp = [AVOfflineComposition aVOfflineComposition];
    
#if defined(HAS_LIB_COMPRESSION_API)
    if ((1)) {
        NSLog(@"compressed-------");
        comp.compressedIntermediate = TRUE;
        comp.compressedOutput = TRUE;
    }
#endif // HAS_LIB_COMPRESSION_API
    
    self.composition = comp;
    
    //监听合成结果通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(finishedLoadNotification:)
                                                 name:AVOfflineCompositionCompletedNotification
                                               object:self.composition];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(failedToLoadNotification:)
                                                 name:AVOfflineCompositionFailedNotification
                                               object:self.composition];
    
    
    NSLog(@"start rendering lossless movie in background");
    NSDictionary *dic = [self getDic];
    //开始合成
    [comp compose:dic];
}

- (NSString *)outputPath {
    return self.converter.outputPath;
}

#pragma mark - Private Method
//解析成字典
- (NSDictionary *)getDic {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result fh_setObject:self.about forKey:kKeyAbout];
    [result fh_setObject:self.source forKey:kKeySource];
    [result fh_setObject:[NSString stringWithFormat:@"%@.mvid",self.destination] forKey:kKeyDestination];
    [result fh_setObject:@(self.comepDurationSeconds) forKey:kKeyCompDurationSeconds];
    [result fh_setObject:@(self.compFramesPerSecond) forKey:kKeyCompFramesPerSecond];
    [result fh_setObject:@(self.compSize.width) forKey:kKeyCompWidth];
    [result fh_setObject:@(self.compSize.height) forKey:kKeyCompHeight];
    [result fh_setObject:@(self.compScale) forKey:kKeyCompScale];
    [result fh_setObject:self.font.fontName forKey:kKeyFont];
    [result fh_setObject:@(self.fontSize) forKey:kKeyFontSize];
    [result fh_setObject:@(self.highQualityInterpolation) forKey:kKeyHighQualityInterpolation];
#warning todo
    [result fh_setObject:@"#FF0000" forKey:kKeyFontColor];
    NSMutableArray *componentDicArray = [[NSMutableArray alloc] init];
    for (FHMediaComponent *component in self.components) {
        [componentDicArray addObject:[component getDic]];
    }
    [result fh_setObject:componentDicArray forKey:kkeyCompClips];
    return result;
}

//合成成功
- (void)finishedLoadNotification:(NSNotification*)notification
{
    if ([self.delegate respondsToSelector:@selector(filterManager:doneWithState:error:)]) {
        [self.delegate filterManager:self doneWithState:FHMediaFilterStateComposeSuccess error:nil];
    }
    NSLog(@"finished rendering lossless movie in : %@",self.composition.destination);
    //转换
    AVAssetWriterConvertFromMaxvid  *testReader = [AVAssetWriterConvertFromMaxvid aVAssetWriterConvertFromMaxvid];
    testReader.inputPath = self.composition.destination;
    NSString *outPath = [AVFileUtil getTmpDirPath:[NSString stringWithFormat:@"%@.m4v",self.destination]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath]){
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedConvert:) name:AVAssetWriterFinishedWriteCompletedNotification object:nil];
    testReader.outputPath = outPath;
    self.converter = testReader;
    //开始转码
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [testReader blockingEncode];
    });
}

//合成失败
- (void)failedToLoadNotification:(NSNotification*)notification
{
    if ([self.delegate respondsToSelector:@selector(filterManager:doneWithState:error:)]) {
        AVOfflineComposition *comp = (AVOfflineComposition*)notification.object;
        NSString *errorString = comp.errorString;
        NSError *error = [NSError errorWithDomain:kErrorDomain code:0 userInfo:@{@"info":errorString}];
        [self.delegate filterManager:self doneWithState:FHMediaFilterStateComposeFailure error:error];
    }
    AVOfflineComposition *comp = (AVOfflineComposition*)notification.object;
    
    NSString *errorString = comp.errorString;
    
    NSLog(@"failed rendering lossless movie: \"%@\"", errorString);
}

//完成转换
- (void)finishedConvert:(NSNotification *)notification {
    NSLog(@"finished convert lossless movie in : %@",self.converter.outputPath);
    if ([self.delegate respondsToSelector:@selector(filterManager:doneWithState:error:)]) {
        [self.delegate filterManager:self doneWithState:FHMediaFilterStateConvertFormatSuccess error:nil];
    }
}


@end
