//
//  UITableViewCell+initCell.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "UITableViewCell+initCell.h"

@implementation UITableViewCell (initCell)

+(id)cellWithTableView:(UITableView *)tableView
{
    NSString *className = NSStringFromClass([self class]);
    
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    
    return [tableView dequeueReusableCellWithIdentifier:className];
}
@end
