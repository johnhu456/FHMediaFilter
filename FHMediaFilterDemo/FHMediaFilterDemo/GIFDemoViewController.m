//
//  GIFDemoViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/16.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "GIFDemoViewController.h"
#import "FHMediaFilterManager.h"
#import "FHMediaComponent.h"

@interface GIFDemoViewController ()

@end

@implementation GIFDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getGifAndDisplay];
    
    // Do any additional setup after loading the view.
}

- (void)getGifAndDisplay {
    FHMediaComponentVideo *testGif = [FHMediaComponentVideo videoComponentWithName:@"test" type:@"gif" rect:self.view.frame];
    FHAnimatorView *gifView = [[FHAnimatorView alloc] initWithVideo:testGif frame:self.view.frame];
    [self.view addSubview:gifView];
    [gifView startAnimateWithRepeat:YES];
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
