//
//  NSDictionary+FHMediaFilterExtension.m
//  FHMediaFilterDemo
//
//  Created by 胡翔 on 2017/1/13.
//  Copyright © 2017年 胡翔. All rights reserved.
//

#import "NSMutableDictionary+FHMediaFilterExtension.h"

@implementation NSMutableDictionary (FHMediaFilterExtension)

-(void)fh_setObject:(id)value forKey:(NSString *)key {
    if (value == nil) {
        return;
    }else {
        [self setObject:value forKey:key];
    }
}
@end
