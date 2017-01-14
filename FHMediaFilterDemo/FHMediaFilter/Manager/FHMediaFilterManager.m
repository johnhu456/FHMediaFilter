//
//  FHMediaFilterManager.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaFilterManager.h"
#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVOfflineComposition.h"
#import "AVFileUtil.h"
#import "AVAssetWriterConvertFromMaxvid.h"

#import "FHMediaComponentVideo.h"
#import "FHMediaComponentImage.h"

#import "NSMutableDictionary+FHMediaFilterExtension.h"

@interface FHAnimatorView() {
    BOOL _repeat;
    AVAnimatorMedia *_mediaCopy;
}
@end
@implementation FHAnimatorView

- (instancetype)initWithComponents:(FHMediaComponentVideo *)component frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        AVAssetJoinAlphaResourceLoader *resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
        resLoader.movieRGBFilename = component.rgbVideoName;
        resLoader.movieAlphaFilename = component.alphaVideoName;
        resLoader.outPath = [AVFileUtil getTmpDirPath:component.clipSource];
        resLoader.alwaysGenerateAdler = TRUE;
        resLoader.serialLoading = TRUE;
        
        AVAnimatorMedia *media = [AVAnimatorMedia aVAnimatorMedia];
        media.resourceLoader = resLoader;
        media.frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];
        _mediaCopy = media;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnimatorFinished:) name:AVAnimatorDidStopNotification object:nil];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self attachMedia:_mediaCopy];
    
}

- (void)startAnimateWithRepeat:(BOOL)repeat {
    _repeat = repeat;
    [_mediaCopy startAnimator];
}

- (void)handleAnimatorFinished:(NSNotification *)notification {
    [_mediaCopy stopAnimator];
    [self attachMedia:nil];
    if (_repeat) {
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

@property (nonatomic, strong) AVOfflineComposition *composition;

@property (nonatomic, strong) AVAssetWriterConvertFromMaxvid *testReader;

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
    [self.components addObject:component];
}

#pragma mark - Public Method
- (void)startFilter {
    //将背景视频转换为mvid
    for (FHMediaComponent *component in self.components) {
        if ([component isKindOfClass:[FHMediaComponentVideo class]]){
            FHMediaComponentVideo *video = (FHMediaComponentVideo *)component;
            AVAssetJoinAlphaResourceLoader *resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
            resLoader.movieRGBFilename = video.rgbVideoName;
            resLoader.movieAlphaFilename = video.alphaVideoName;
            resLoader.outPath = [AVFileUtil getTmpDirPath:[NSString stringWithFormat:@"%@.mvid",component.clipSource]];
            resLoader.alwaysGenerateAdler = TRUE;
            resLoader.serialLoading = TRUE;
            [resLoader load];
        }
    }

    AVOfflineComposition *comp = [AVOfflineComposition aVOfflineComposition];
    
#if defined(HAS_LIB_COMPRESSION_API)
    if ((1)) {
        comp.compressedIntermediate = TRUE;
        comp.compressedOutput = TRUE;
    }
#endif // HAS_LIB_COMPRESSION_API
    
    self.composition = comp;
    
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
    [comp compose:dic];
}

- (NSDictionary *)getDic {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result fh_setObject:self.about forKey:kKeyAbout];
    [result fh_setObject:self.source forKey:kKeySource];
    [result fh_setObject:self.destination forKey:kKeyDestination];
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

#pragma mark - Private Method
- (void)finishedLoadNotification:(NSNotification*)notification
{
    NSLog(@"finished rendering lossless movie");
    NSLog(@"%@",self.composition.destination);
    //转换
    AVAssetWriterConvertFromMaxvid  *testReader = [AVAssetWriterConvertFromMaxvid aVAssetWriterConvertFromMaxvid];
    testReader.inputPath = self.composition.destination;
    NSString *outPath = [AVFileUtil getTmpDirPath:@"test.m4v"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPath]){
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:nil];
    }
    NSLog(@"%@",outPath);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(encode:) name:AVAssetWriterConvertFromMaxvidCompletedNotification object:nil];
    testReader.outputPath = outPath;
    self.testReader = testReader;
    [testReader blockingEncode];
}

- (void)failedToLoadNotification:(NSNotification*)notification
{
    AVOfflineComposition *comp = (AVOfflineComposition*)notification.object;
    
    NSString *errorString = comp.errorString;
    
    NSLog(@"failed rendering lossless movie: \"%@\"", errorString);
}

- (void)encode:(NSNotification *)notification {
    NSLog(@"%@",notification);
}


@end
