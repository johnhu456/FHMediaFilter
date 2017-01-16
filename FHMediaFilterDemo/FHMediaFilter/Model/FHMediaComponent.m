//
//  FHMediaComponent.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponent.h"

@implementation FHMediaComponent

- (NSDictionary *)getDic {
    //解析成字典
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result fh_setObject:self.clipSource forKey:kKeyClipSource];
    [result fh_setObject:[self getClipTypeName] forKey:kKeyClipType];
    [result fh_setObject:@(self.clipRect.origin.x) forKey:kKeyClipX];
    [result fh_setObject:@(self.clipRect.origin.y) forKey:kKeyClipY];
    [result fh_setObject:@(self.clipRect.size.width) forKey:kKeyClipWidth];
    [result fh_setObject:@(self.clipRect.size.height) forKey:kKeyClipHeight];
    [result fh_setObject:@(self.clipRect.size.height) forKey:kKeyClipHeight];
    [result fh_setObject:@(self.clipStartSeconds) forKey:kKeyClipStartSeconds];
    [result fh_setObject:@(self.clipEndSeconds) forKey:kKeyClipEndSeconds];
    return result;
}

#pragma mark - Private Method
//讲clipType解析成特定字符串
- (NSString *)getClipTypeName {
    switch (self.clipType) {
        case FHMediaComponentTypeText:
            return @"text";
            break;
        case FHMediaComponentTypeImage:
            return @"image";
            break;
#warning 待优化，可能增加多格式视频支持
        case FHMediaComponentTypeVideo:
            return @"mvid";
            break;
        default:
            return @"";
            break;
    }
}
@end

#pragma mark - FHMediaComponentVideo

@implementation FHMediaComponentVideo

+ (instancetype)videoComponentWithName:(NSString *)name type:(NSString *)type rect:(CGRect)rect {
    FHMediaComponentVideo *result = [[FHMediaComponentVideo alloc] init];
    //判断格式自动生成两种通道文件名称。
    if ([type isEqualToString:@"m4v"]) {
        result.alphaVideoName = [NSString stringWithFormat:@"%@_alpha.m4v",name];
        result.rgbVideoName = [NSString stringWithFormat:@"%@_rgb.m4v",name];
    }else if ([type isEqualToString:@"mov"]) {
        result.alphaVideoName = [NSString stringWithFormat:@"%@.mov",name];
        result.rgbVideoName = [NSString stringWithFormat:@"%@.mov",name];
    }else if ([type isEqualToString:@"gif"]) {
        result.alphaVideoName = [NSString stringWithFormat:@"%@.gif",name];
        result.rgbVideoName = [NSString stringWithFormat:@"%@.gif",name];
    }else {
        [NSException exceptionWithName:@"Unsupport Type" reason:@"FHMediaComponentVideo now can only support type m4v or mov video"
                              userInfo:nil];
        return nil;
    }
    result.clipRect = rect;
    result.clipSource = [NSString stringWithFormat:@"%@.mvid",name];
    result.clipType = FHMediaComponentTypeVideo;
    return result;
}

@end

#pragma mark - FHMediaComponentImage
@implementation FHMediaComponentImage

+ (instancetype)imageComponentWithName:(NSString *)name rect:(CGRect)rect {
    FHMediaComponentImage *result = [[FHMediaComponentImage alloc] init];
    result.clipRect = rect;
    result.clipSource = name;
    result.clipType = FHMediaComponentTypeImage;
    return result;
}
@end
