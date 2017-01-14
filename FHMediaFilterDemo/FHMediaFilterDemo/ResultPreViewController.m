//
//  ResultPreViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/14.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "ResultPreViewController.h"

@interface ResultPreViewController ()<FHMediaFilterManagerDelegate>

@property (nonatomic, strong) FHMediaFilterManager *filterManager;
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
    UIImage *image = [UIImage imageNamed:self.imageName];
    FHMediaComponentImage *imageComponent = [FHMediaComponentImage imageComponentWithName:self.imageName rect:CGRectMake(0, 0, 800, 600)];
    imageComponent.clipEndSeconds = 3.f;
    self.video.clipEndSeconds = 3.f;
    self.video.clipRect = CGRectMake(0, 0, 800, 600);
    FHMediaFilterManager *filterManager = [[FHMediaFilterManager alloc] init];
    [filterManager addComponent:imageComponent];
    [filterManager addComponent:self.video];
    filterManager.about = @"Comp 2 videos text at full screen 2x size with subtitles";
    filterManager.destination = @"new.mvid";
    filterManager.source = @"Comp.plist";
    filterManager.comepDurationSeconds = 3;
    filterManager.compFramesPerSecond = 30;
    filterManager.compSize = CGSizeMake(800, 600);
    filterManager.compScale = 0;
    filterManager.font = [UIFont fontWithName:@"AmericanTypewriter" size:14];
    filterManager.fontSize = 14;
    self.filterManager = filterManager;
    NSLog(@"%@",[filterManager getDic]);
    [filterManager startFilter];
        // Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view.
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
