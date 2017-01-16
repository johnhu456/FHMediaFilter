//
//  FHMediaFilterManager.h
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FHMediaComponent.h"

#import "AVMvidFrameDecoder.h"
#import "AVFileUtil.h"
#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVAnimatorMedia.h"
#import "AVAnimatorView.h"

#pragma mark - SubClass of AVAnimatorView
@class FHMediaFilterManager;

@interface FHAnimatorView : AVAnimatorView

/**
 通过视频组件生成FHAnimatorView(支持gif展示)

 @param video 视频组件
 @param frame 大小及位置
 */
- (instancetype)initWithVideo:(FHMediaComponentVideo *)video
                        frame:(CGRect)frame;


/**
 开始播放动画

 @param repeat 是否重复播放
 */
- (void)startAnimateWithRepeat:(BOOL)repeat;

@end

#pragma mark - Protocol
typedef NS_ENUM(NSUInteger,FHMediaFilterState){
    FHMediaFilterStateComposeSuccess = 0,   //合成成功
    FHMediaFilterStateComposeFailure,       //合成失败
    FHMediaFilterStateConvertFormatSuccess, //转换格式成功
    FHMediaFilterStateConvertFormatFailure  //转换格式失败
};

@protocol FHMediaFilterManagerDelegate <NSObject>

/**
 完成视频合成的回调
 
 @param manager 当前FHMediaFilterManager
 @param state 当前完成状态
 @param error 错误信息，成功则为空
 */
- (void)filterManager:(FHMediaFilterManager *)manager
                doneWithState:(FHMediaFilterState )state
                error:(NSError *)error;

@end

@interface FHMediaFilterManager : NSObject

@property (nonatomic, copy) NSString *about;

@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, assign) CGFloat comepDurationSeconds;
@property (nonatomic, assign) CGFloat compFramesPerSecond;
@property (nonatomic, assign) CGSize compSize;
@property (nonatomic, assign) CGFloat compScale;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *fontColor;
@property (nonatomic, assign) BOOL highQualityInterpolation;

/**
 代理对象
 */
@property (nonatomic, weak) id<FHMediaFilterManagerDelegate>delegate;

/**
 合成所需的组件数组
 Media components array;
 */
@property (nonatomic, strong, readonly) NSMutableArray<FHMediaComponent*> *components;


@property (nonatomic, strong) AVAnimatorView *currentAnimatorView;

- (void)addComponent:(FHMediaComponent *)component;

/**
 开始合成，转换格式并输出
 */
- (void)startComposeAndOutput;

/**
 输出文件所在位置
 */
- (NSString *)outputPath;

@end
