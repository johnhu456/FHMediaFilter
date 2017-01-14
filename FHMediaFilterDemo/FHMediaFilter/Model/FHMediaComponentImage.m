//
//  FHMediaComponentImage.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponentImage.h"

@implementation FHMediaComponentImage

+ (instancetype)imageComponentWithName:(NSString *)name rect:(CGRect)rect {
    FHMediaComponentImage *result = [[FHMediaComponentImage alloc] init];
    result.clipRect = rect;
    result.clipSource = name;
    result.clipType = FHMediaComponentTypeImage;
    return result;
}
@end
