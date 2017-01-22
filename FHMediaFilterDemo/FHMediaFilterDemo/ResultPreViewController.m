//
//  ResultPreViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/14.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "ResultPreViewController.h"
#import <AVFoundation/AVFoundation.h>

#import <SSZipArchive.h>

@interface ResultPreViewController ()<FHMediaFilterManagerDelegate>

@property (nonatomic, strong) FHMediaFilterManager *filterManager;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) AVPlayer *player;

@end

@implementation ResultPreViewController

- (instancetype)initWithImageName:(NSString *)imageName video:(FHMediaComponentVideo *)video {
    if (self = [super init]) {
        self.imageName = imageName;
        self.video = video;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupActivityView];
        // Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view.
}

- (void)setupActivityView {
    self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.activityView.hidesWhenStopped = YES;
    self.activityView.center = self.view.center;
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
    [self composeVideo];
}

- (void)addVideoPlayView {
    [self.activityView stopAnimating];
    AVPlayer *player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:self.filterManager.outputPath]];
    self.player = player;
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playLayer.frame = CGRectMake(0, 80, self.filterManager.compSize.width, self.filterManager.compSize.height);
    [self.view.layer addSublayer:playLayer];
    [player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playRepeat:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)composeVideo {
    FHMediaComponentImage *imageComponent = [FHMediaComponentImage imageComponentWithName:self.imageName rect:CGRectMake(0, 0, 375, 300)];
    imageComponent.clipEndSeconds = 3.f;
    self.video.clipEndSeconds = 3.f;
    self.video.clipRect = CGRectMake(0, 0, 375, 300);
    
    
    FHMediaFilterManager *filterManager = [[FHMediaFilterManager alloc] init];
    filterManager.delegate = self;
    [filterManager addComponent:imageComponent]; //添加图片
    [filterManager addComponent:self.video];  //添加视频
    
//    FHMediaComponentVideo *maskVideo = [FHMediaComponentVideo videoComponentWithName:@"0_mask" type:@"mov" rect:CGRectMake(0, 0, 375, 300)];
//    maskVideo.alphaVideoName = @"0_mask_alpha.mov";
//    maskVideo.rgbVideoName = @"0_mask_rgb.mov";
//    maskVideo.clipEndSeconds = 3.f;
//    [filterManager addComponent:maskVideo];
//    FHMediaComponentImage *icon = [FHMediaComponentImage imageComponentWithName:@"LOGO@2x" rect:CGRectMake(330, 250, 30, 30)];
//    icon.clipEndSeconds = 3.f;
//    [filterManager addComponent:icon];
    
    filterManager.about = @"Comp 2 videos text at full screen 2x size with subtitles"; //没什么用
    filterManager.destination = @"result";  //输出文件名
    filterManager.source = @"Comp.plist"; //没什么用
    filterManager.comepDurationSeconds = 3;  //持续时间
    filterManager.compFramesPerSecond = 30;  //帧数
    filterManager.compSize = CGSizeMake(400, 300);  //大小
    filterManager.compScale = 0; //屏幕像素倍数
    filterManager.font = [UIFont fontWithName:@"AmericanTypewriter" size:14];  //暂时没什么用
    filterManager.fontSize = 14;  //暂时没用
    self.filterManager = filterManager;
    [filterManager startComposeAndOutput];
}

- (void)filterManager:(FHMediaFilterManager *)manager doneWithState:(FHMediaFilterState)state error:(NSError *)error {
    if (state == FHMediaFilterStateConvertFormatSuccess) {
        //回主线程播放
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addVideoPlayView];
        });
        //压缩
        [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@.zip",self.filterManager.outputPath] withFilesAtPaths:@[self.filterManager.outputPath]];
    }
}

- (void)playRepeat:(NSNotification *)notification {
    AVPlayerItem * p = [notification object];
    //关键代码
    [p seekToTime:kCMTimeZero];
    
    [self.player play];
    NSLog(@"重播");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
