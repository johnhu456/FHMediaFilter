//
//  ViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "ViewController.h"
#import "FHMediaFilterManager.h"
#import "FHMediaComponentVideo.h"
#import "FHMediaComponentImage.h"

@interface ViewController ()

@property (nonatomic, strong) FHMediaFilterManager *filterManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.window = self.view.window;
    
    [self.view.window removeFromSuperview];
    FHMediaComponentImage *imageComponent = [FHMediaComponentImage imageComponentWithName:@"6" rect:self.view.frame];
    imageComponent.clipEndSeconds = 3.f;
    FHMediaComponentVideo *videoComponent = [FHMediaComponentVideo videoComponentWithName:@"0113snow_screen" rect:self.view.frame];
    videoComponent.clipEndSeconds = 3.f;
    FHMediaFilterManager *filterManager = [[FHMediaFilterManager alloc] init];
    [filterManager addComponent:imageComponent];
    [filterManager addComponent:videoComponent];
    filterManager.about = @"Comp 2 videos text at full screen 2x size with subtitles";
    filterManager.destination = @"new.mvid";
    filterManager.source = @"Comp.plist";
    filterManager.comepDurationSeconds = 3;
    filterManager.compFramesPerSecond = 30;
    filterManager.compSize = self.view.frame.size;
    filterManager.compScale = 0;
    filterManager.font = [UIFont fontWithName:@"AmericanTypewriter" size:14];
    filterManager.fontSize = 14;
    self.filterManager = filterManager;
    NSLog(@"%@",[filterManager getDic]);
    [filterManager startFilter];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
