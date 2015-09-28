//
//  WJSubject.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WJSubject.h"

@implementation WJSubject

+(id)subjectWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}

//重写description方法
-(NSString *)description
{
    return [NSString stringWithFormat:@"title = %@,note = %@",_title,_note];
}
@end
