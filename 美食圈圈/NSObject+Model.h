//
//  NSObject+Model.h
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

+(id)objectWithDict:(NSDictionary *)dict;
-(id)initWithDict:(NSDictionary *)dict;
@end
