//
//  WJSubjectCell.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WJSubjectCell.h"

@interface WJSubjectCell()

@end

@implementation WJSubjectCell

-(void) setSubject:(WJSubject *)subject
{
    _subject = subject;
    
    //更新子控件内容
    self.iconImageView.image = [UIImage imageNamed:subject.icon];
    self.titleLabel.text = subject.title;
}

+(id)subjectCellWithTableView:(UITableView *)tableView
{
    /*
    WJSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[WJSubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"afdf";
     */
    
    /* 无法复用
    return [[NSBundle mainBundle]loadNibNamed:@"WJSubjectCell" owner:nil options:nil];
    */
    
    /*操作复杂,不方便使用,还要在xib文件中设置reuse Identifier 为@"A"才能复用
    WJSubjectCell * cell = [tableView dequeueReusableCellWithIdentifier:@"A"];
    
    if (cell == nil)
    {
        //苹果公司建议我们经常性加载的xib文件要使用UINib
        
        UINib * nib = [UINib nibWithNibName:@"WJSubjectCell" bundle:nil];
        cell = [[nib instantiateWithOwner:nil options:nil] lastObject];
    }
    */
    
    /* 这种方式可以复用,但是却太麻烦，所以可以封装起来
    NSString *className = NSStringFromClass([self class]);
    
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    
    //如果有可重用的返回，如果没有可重用的创建一个新的返回
    return [tableView dequeueReusableCellWithIdentifier:className];
     */
    
    return [self cellWithTableView:tableView];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
