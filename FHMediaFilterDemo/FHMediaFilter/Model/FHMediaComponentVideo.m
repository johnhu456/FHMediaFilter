//
//  FHMediaComponentVideo.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponentVideo.h"

@implementation FHMediaComponentVideo

+ (instancetype)videoComponentWithName:(NSString *)name type:(NSString *)type rect:(CGRect)rect {
    FHMediaComponentVideo *result = [[FHMediaComponentVideo alloc] init];
    if ([type isEqualToString:@"m4v"]) {
        result.alphaVideoName = [NSString stringWithFormat:@"%@_alpha.m4v",name];
        result.rgbVideoName = [NSString stringWithFormat:@"%@_rgb.m4v",name];
    }else if ([type isEqualToString:@"mov"]) {
        result.alphaVideoName = [NSString stringWithFormat:@"%@.mov",name];
        result.rgbVideoName = [NSString stringWithFormat:@"%@.mov",name];
    }else {
        [NSException exceptionWithName:@"Unsupport Type" reason:@"FHMediaComponentVideo now can only support type m4v or mov video with alpha chanel" userInfo:nil];
        return nil;
    }
    result.clipRect = rect;
    result.clipSource = [NSString stringWithFormat:@"%@.mvid",name];
    result.clipType = FHMediaComponentTypeVideo;
//    result.clipScaleFramePerSecond = NO;
    //clipStartSeconds and clipEndSeconds 默认与该视频长度一致。
    return result;
}

//- (NSDictionary *)getDic {
//    NSMutableDictionary *superResult = [[super getDic] mutableCopy];
//    NSString *newSource = [NSString stringWithFormat:@"%@.mvid",superResult[kKeyClipSource]];
//    [superResult setObject:newSource forKey:kKeyClipSource];
//    return superResult;
//}

@end
