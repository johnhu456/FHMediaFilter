//
//  ViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "ViewController.h"

#import "RenderViewController.h"
#import "GIFDemoViewController.h"

#import "FHMediaFilterManager.h"
#import "FHMediaComponent.h"

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
    return 9;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 8) {
        UITableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
        if (imageCell == nil) {
            imageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kReuseIdentifier];
        }
        imageCell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        imageCell.textLabel.text = nil;
        return imageCell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier];
        cell.imageView.image = nil;
        cell.textLabel.text = @"gif";
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 8) {
        NSString *imageName = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        RenderViewController *renderViewController = [[RenderViewController alloc] initWithNibName:@"RenderViewController" bundle:nil];
        renderViewController.imageName = imageName;
        [self.navigationController pushViewController:renderViewController animated:YES];
    }else {
        GIFDemoViewController *gifVC = [[GIFDemoViewController alloc] init];
        [self.navigationController pushViewController:gifVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
