//
//  FHMediaComponent.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "FHMediaComponent.h"

@implementation FHMediaComponent
//@property (nonatomic, copy) NSString *clipSource;
//@property (nonatomic, assign) FHMediaComponentType clipType;
//@property (nonatomic, assign) CGRect clipRect;
//@property (nonatomic, assign) CGFloat clipStartSeconds;      //默认为0;
//@property (nonatomic, assign) CGFloat clipEndSeconds;        //默认与FHMediaFilteManager的长度一致
//@property (nonatomic, assign) BOOL clipScaleFramePerSecond;  //Default is NO;

- (NSDictionary *)getDic {
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
//    [result fh_setObject:@(self.clipScaleFramePerSecond) forKey:kKeyClipScaleFramePerSecond];
    return result;
}

#pragma mark - Private Method
- (NSString *)getClipTypeName {
    switch (self.clipType) {
        case FHMediaComponentTypeText:
            return @"text";
            break;
        case FHMediaComponentTypeImage:
            return @"image";
            break;
#warning 待优化
        case FHMediaComponentTypeVideo:
            return @"mvid";
            break;
        default:
            return @"";
            break;
    }
}
@end
