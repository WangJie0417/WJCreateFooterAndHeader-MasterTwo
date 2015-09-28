//
//  NSArray+desc.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NSArray+desc.h"

@implementation NSArray (desc)

//打印数组时调用
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString * mutString = [NSMutableString string];
    [mutString appendString:@"(\n"];
    for (id obj in self) {
        NSString *str = [obj description];
        [mutString appendFormat:@"\t\n%@",str];
    }
    
    [mutString appendString:@")\n"];
    
    return mutString;
}

-(NSString *)description
{
    return @"adfsd";
}
@end
