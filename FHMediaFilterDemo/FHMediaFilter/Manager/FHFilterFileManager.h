
//
//  FHFilterFileManager.h
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/19.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol  FHFilterFileManagerDelegate <NSObject>

/**
 滤镜压缩回调

 @param exist 是否存在mvid
 @param mvidPath mvid文件路径
 */
- (void)checkMVIDFileDoneWithExist:(BOOL)exist mvidPath:(NSString *)mvidPath;

@end

@interface FHFilterFileManager : NSObject

@property (nonatomic, weak) id<FHFilterFileManagerDelegate>delegate;

+ (instancetype)sharedManager;
/**
 滤镜压缩
 输入MP4,查找是否存在对应的mvid文件

 @param mp4Path MP4 path
 @param zipPath 输出的zip路径
 @param rect 视频大小
 */
- (void)checkMVIDFileWithMP4Path:(NSString *)mp4Path zipOutpath:(NSString *)zipPath rect:(CGRect)rect;

@end
