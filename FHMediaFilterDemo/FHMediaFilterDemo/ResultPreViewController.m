//
//  ResultPreViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/14.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "ResultPreViewController.h"
#import <AVFoundation/AVFoundation.h>

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
    playLayer.frame = CGRectMake(10, 70, self.filterManager.compSize.width, self.filterManager.compSize.height);
    [self.view.layer addSublayer:playLayer];
    [player play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playRepeat:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)composeVideo {
    FHMediaComponentImage *imageComponent = [FHMediaComponentImage imageComponentWithName:self.imageName rect:CGRectMake(0, 0, 400, 300)];
    imageComponent.clipEndSeconds = 3.f;
    self.video.clipEndSeconds = 3.f;
    self.video.clipRect = CGRectMake(0, 0, 400, 300);
    FHMediaFilterManager *filterManager = [[FHMediaFilterManager alloc] init];
    filterManager.delegate = self;
    [filterManager addComponent:imageComponent];
    [filterManager addComponent:self.video];
    filterManager.about = @"Comp 2 videos text at full screen 2x size with subtitles";
    filterManager.destination = @"result";
    filterManager.source = @"Comp.plist";
    filterManager.comepDurationSeconds = 3;
    filterManager.compFramesPerSecond = 30;
    filterManager.compSize = CGSizeMake(400, 300);
    filterManager.compScale = 0;
    filterManager.font = [UIFont fontWithName:@"AmericanTypewriter" size:14];
    filterManager.fontSize = 14;
    self.filterManager = filterManager;
    [filterManager startComposeAndOutput];
}

- (void)filterManager:(FHMediaFilterManager *)manager doneWithState:(FHMediaFilterState)state error:(NSError *)error {
    if (state == FHMediaFilterStateConvertFormatSuccess) {
        [self addVideoPlayView];
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
