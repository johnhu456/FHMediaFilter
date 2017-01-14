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

