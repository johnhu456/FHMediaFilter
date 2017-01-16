//
//  FHMediaComponent.h
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSMutableDictionary+FHMediaFilterExtension.h"

typedef NS_ENUM(NSUInteger,FHMediaComponentType){
    //组件类型
    FHMediaComponentTypeVideo=0,
    FHMediaComponentTypeImage,
    FHMediaComponentTypeText,
};

#pragma mark - KeyNames
static NSString *const kKeyClipSource = @"ClipSource";
static NSString *const kKeyClipType = @"ClipType";
static NSString *const kKeyClipX = @"ClipX";
static NSString *const kKeyClipY = @"ClipY";
static NSString *const kKeyClipWidth = @"ClipWidth";
static NSString *const kKeyClipHeight = @"ClipHeight";
static NSString *const kKeyClipStartSeconds = @"ClipStartSeconds";
static NSString *const kKeyClipEndSeconds = @"ClipEndSeconds";


@interface FHMediaComponent : NSObject

/**
 文件源名称
 文字则为字符串内容
 图片为图片名
 视频为不含后缀的视频名称
 
 注意:
 文件源除文字内容外，其余都需要将资源置于App资源包内或者AVFileUtil所交互的临时文件夹内(/tmp)
 */
@property (nonatomic, copy) NSString *clipSource;

/**
 组件类型
 详细参见FHMediaComponentType
 */
@property (nonatomic, assign) FHMediaComponentType clipType;

/**
 内容位置
 组件合成后所在的位置和大小
 */
@property (nonatomic, assign) CGRect clipRect;

/**
 开始时间
 默认为0
 */
@property (nonatomic, assign) CGFloat clipStartSeconds;

/**
 结束时间
 */
@property (nonatomic, assign) CGFloat clipEndSeconds;

/**
 解析为特定的字典格式
 */
- (NSDictionary *)getDic;

@end

#pragma mark - FHMediaComponentVideo
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
 快捷生成视频组件方法,支持gif
 
 @param name 视频/gif文件名称，视频文件需要存在于App资源包或者/tmp文件夹下
 @param type 文件类型，目前仅支持m4v/mov/gif
 @param rect 视频/gif位置及大小
 @return 视频组件
 */
+ (instancetype)videoComponentWithName:(NSString *)name type:(NSString *)type rect:(CGRect)rect;

@end

#pragma mark - FHMediaComponentImage
@interface FHMediaComponentImage : FHMediaComponent

/**
 快捷生成图片组件的方法
 
 @param name 图片资源名，图片文件需要存在于App资源包或者/tmp文件夹下
 @param rect 图片位置及大小
 */
+ (instancetype)imageComponentWithName:(NSString *)name rect:(CGRect)rect;

@end

#warning 功能待完善
@interface FHMediaComponentText : FHMediaComponent

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *fontColor;

@end
