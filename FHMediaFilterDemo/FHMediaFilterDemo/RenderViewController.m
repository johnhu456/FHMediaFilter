//
//  RenderViewController.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/14.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "RenderViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <SSZipArchive.h>

#import "ResultPreViewController.h"
#import "FHMediaFilterManager.h"
#import "FHFilterFileManager.h"

#import "FilterCollectionViewCell.h"

@interface RenderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SSZipArchiveDelegate,FHFilterFileManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIImage *> *videoThumbnails;

@property (nonatomic, strong) FHMediaComponentVideo *video;

@end

static NSString *const kReuseIdentifier = @"kReuseIdentifier";
@implementation RenderViewController

- (NSMutableArray *)videoThumbnails {
    if (_videoThumbnails == nil) {
        _videoThumbnails = [[NSMutableArray alloc] init];
    }
    return _videoThumbnails;
}
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:_imageName];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self getVideoThumbnailImages];
    self.imageView.image = [UIImage imageNamed:_imageName];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kReuseIdentifier];
    // Do any additional setup after loading the view from its nib.
}

- (void)setupNavigationBar {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(handleDoneButton:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

#pragma mark - Get Image
- (void)getVideoThumbnailImages {
    NSString *snowURL = [[NSBundle mainBundle] pathForResource:@"filter_test01" ofType:@"mp4"];
    NSString *snow2URL = [[NSBundle mainBundle] pathForResource:@"filter_test02" ofType:@"mp4"];
    [self.videoThumbnails addObject:[self thumbnailImageForVideo:[NSURL fileURLWithPath:snowURL] atTime:1]];
    [self.videoThumbnails addObject:[self thumbnailImageForVideo:[NSURL fileURLWithPath:snow2URL] atTime:1]];
    
    for (int i = 2; i< 8; i ++) {
        NSString *videoURL = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d_rgb",i] ofType:@"m4v"];
        [self.videoThumbnails addObject:[self thumbnailImageForVideo:[NSURL fileURLWithPath:videoURL] atTime:1]];
    }
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeProductionAperture;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]: nil;
    
    return thumbnailImage;
}

- (void)handleDoneButton:(UIBarButtonItem *)sender {
    ResultPreViewController *previewVC = [[ResultPreViewController alloc] initWithImageName:self.imageName video:self.video];
    [self.navigationController pushViewController: previewVC animated:YES];
}

#pragma mark - UICollectionViewDataSource/Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  self.videoThumbnails.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FilterCollectionViewCell *cell = (FilterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.imageView.image = self.videoThumbnails[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //滤镜展示合成
    
    //添加滤镜展示View
    if (indexPath.row > 1) {
        while (self.imageView.subviews.count) {
            [self.imageView.subviews[0] removeFromSuperview];
        }
        FHMediaComponentVideo *video = [FHMediaComponentVideo videoComponentWithName:[NSString stringWithFormat:@"%ld",(long)indexPath.row] type:@"m4v" rect:self.imageView.bounds];
        FHAnimatorView *view = [[FHAnimatorView alloc] initWithVideo:video frame:self.imageView.bounds];
        [self.imageView addSubview:view];
        [view startAnimateWithRepeat:YES];
        self.video = video;
    }else if (indexPath.row == 0){
        while (self.imageView.subviews.count) {
            [self.imageView.subviews[0] removeFromSuperview];
        }
        FHMediaComponentVideo *video = [FHMediaComponentVideo videoComponentWithName:@"filter_test01" type:@"mp4" rect:self.imageView.bounds];
        FHAnimatorView *view = [[FHAnimatorView alloc] initWithVideo:video frame:self.imageView.bounds];
        [self.imageView addSubview:view];
        [view startAnimateWithRepeat:YES];
        self.video = video;
    }else if (indexPath.row == 1) {
        while (self.imageView.subviews.count) {
            [self.imageView.subviews[0] removeFromSuperview];
        }
        
        
        
        NSString *local = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"filter_test02copy.mp4"];
        NSString *mvidLocal = [[local stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"test.zip"];
//        FHMediaComponentVideo *video = [FHMediaComponentVideo videoComponentWithName:local type:@"mp4" rect:self.imageView.bounds];
         FHMediaComponentVideo *video = [FHMediaComponentVideo videoComponentWithName:@"filter_test01" type:@"mp4" rect:self.imageView.bounds];
        [FHFilterFileManager sharedManager].delegate = self;
        video.clipSource = @"test.mvid";
        self.video = video;
        [[FHFilterFileManager sharedManager] checkMVIDFileWithMP4Path:local zipOutpath:mvidLocal rect:CGRectMake(0, 0, 400, 300)];

    }
}

- (void)checkMVIDFileDoneWithExist:(BOOL)exist mvidPath:(NSString *)mvidPath {
    NSLog(@"%@",exist?@"YES" : @"NO");
    NSLog(@"%@",mvidPath);
    FHAnimatorView *view = [[FHAnimatorView alloc] initWithVideo:self.video frame:self.imageView.bounds];
    [self.imageView addSubview:view];
    [view startAnimateWithRepeat:YES];
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath {

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
