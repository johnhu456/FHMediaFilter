//
//  FHMediaComponentVideo.h
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponent.h"
#import <UIKit/UIKit.h>
@interface FHMediaComponentVideo : FHMediaComponent

//如果生成时传入的type为“m4v”，会自动生成名为“name_alpha.m4v”的alphaName
@property (nonatomic, strong) NSString *alphaVideoName;

//如果生成时传入的type为“m4v”，会自动生成名为“name_rgb.m4v”的alphaName
@property (nonatomic, strong) NSString *rgbVideoName;

+ (instancetype)videoComponentWithName:(NSString *)name type:(NSString *)type rect:(CGRect)rect;

@end
