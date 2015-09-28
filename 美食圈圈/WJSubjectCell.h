//
//  WJSubjectCell.h
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSubject.h"
#import "UITableViewCell+initCell.h"

@interface WJSubjectCell : UITableViewCell

@property (nonatomic,strong) WJSubject * subject;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(id)subjectCellWithTableView:(UITableView *)tableView;

@end
