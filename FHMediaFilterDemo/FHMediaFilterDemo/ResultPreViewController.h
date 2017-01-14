//
//  ResultPreViewController.h
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/14.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FHMediaComponentVideo.h"
#import "FHMediaFilterManager.h"
#import "FHMediaComponentImage.h"

@interface ResultPreViewController : UIViewController

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) FHMediaComponentVideo *video;

- (instancetype)initWithImageName:(NSString *)imageName
                            video:(FHMediaComponentVideo *)video;

@end
