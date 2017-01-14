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
#import "FHMediaComponentVideo.h"

#import "AVMvidFrameDecoder.h"
#import "AVFileUtil.h"
#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVAnimatorMedia.h"
#import "AVAnimatorView.h"

#pragma mark - SubClass of AVAnimatorView
@interface FHAnimatorView : AVAnimatorView

- (instancetype)initWithComponents:(FHMediaComponentVideo *)component
                                            frame:(CGRect)frame;

- (void)startAnimateWithRepeat:(BOOL)repeat;

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
 Media components array;
 */
@property (nonatomic, strong, readonly) NSMutableArray<FHMediaComponent*> *components;


@property (nonatomic, strong) AVAnimatorView *currentAnimatorView;

- (void)addComponent:(FHMediaComponent *)component;

- (void)startFilter;

#warning test Method
- (NSDictionary *)getDic;

@end
