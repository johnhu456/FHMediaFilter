//
//  ViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "ViewController.h"

#import "RenderViewController.h"

#import "FHMediaFilterManager.h"
#import "FHMediaComponentVideo.h"
#import "FHMediaComponentImage.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) FHMediaFilterManager *filterManager;
@end

static NSString  *const kReuseIdentifier = @"kReuseIdentifier";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
    if (imageCell == nil) {
        imageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
    }
    imageCell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    return imageCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageName = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    RenderViewController *renderViewController = [[RenderViewController alloc] initWithNibName:@"RenderViewController" bundle:nil];
    renderViewController.imageName = imageName;
    [self.navigationController pushViewController:renderViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
