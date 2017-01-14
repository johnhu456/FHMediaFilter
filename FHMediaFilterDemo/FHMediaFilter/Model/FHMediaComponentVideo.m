//
//  FHMediaComponentVideo.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponentVideo.h"

@implementation FHMediaComponentVideo

+ (instancetype)videoComponentWithName:(NSString *)name rect:(CGRect)rect {
    FHMediaComponentVideo *result = [[FHMediaComponentVideo alloc] init];
    result.clipRect = rect;
    result.clipSource = name;
    result.clipType = FHMediaComponentTypeVideo;
//    result.clipScaleFramePerSecond = NO;
    //clipStartSeconds and clipEndSeconds 默认与该视频长度一致。
    return result;
}

- (NSDictionary *)getDic {
    NSMutableDictionary *superResult = [[super getDic] mutableCopy];
    NSString *newSource = [NSString stringWithFormat:@"%@.mvid",superResult[kKeyClipSource]];
    [superResult setObject:newSource forKey:kKeyClipSource];
    return superResult;
}

@end
