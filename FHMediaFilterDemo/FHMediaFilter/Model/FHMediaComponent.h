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
//static NSString *const kKeyClipScaleFramePerSecond = @"ClipScaleFramePerSecond";


@interface FHMediaComponent : NSObject

@property (nonatomic, copy) NSString *clipSource;
@property (nonatomic, assign) FHMediaComponentType clipType;
@property (nonatomic, assign) CGRect clipRect;
@property (nonatomic, assign) CGFloat clipStartSeconds;      //默认为0;
@property (nonatomic, assign) CGFloat clipEndSeconds;        //默认与FHMediaFilteManager的长度一致
//@property (nonatomic, assign) BOOL clipScaleFramePerSecond;  //Default is NO;

#warning test method
- (NSDictionary *)getDic;
@end
