//
//  NSObject+Model.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "NSObject+Model.h"

@implementation NSObject (Model)

+(id)objectWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
-(id)initWithDict:(NSDictionary *)dict
{
    if(self = [self init])
    {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
