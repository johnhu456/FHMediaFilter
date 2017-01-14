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

/**
 alpha通道的视频文件名称
 如果生成时传入的type为“m4v”，会自动生成名为“name_alpha.m4v”的alphaName
 */
@property (nonatomic, strong) NSString *alphaVideoName;

/**
 rgb通道的视频文件名称
 如果生成时传入的type为“m4v”，会自动生成名为“name_rgb.m4v”的alphaName
 */
@property (nonatomic, strong) NSString *rgbVideoName;

/**
 快捷生成视频组件方法

 @param name 视频文件名称，视频文件需要存在于App资源包或者/tmp文件夹下
 @param type 视频类型，目前仅支持m4v/mov
 @param rect 视频位置及大小
 @return 视频组件
 */
+ (instancetype)videoComponentWithName:(NSString *)name type:(NSString *)type rect:(CGRect)rect;

@end
