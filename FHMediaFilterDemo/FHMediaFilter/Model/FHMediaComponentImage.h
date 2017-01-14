//
//  FHMediaComponentImage.h
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponent.h"

@interface FHMediaComponentImage : FHMediaComponent

/**
 快捷生成图片组件的方法

 @param name 图片资源名，图片文件需要存在于App资源包或者/tmp文件夹下
 @param rect 图片位置及大小
 */
+ (instancetype)imageComponentWithName:(NSString *)name rect:(CGRect)rect;

@end
