//
//  WJFooterView.h
//  美食圈圈
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJFooterView;

enum FooterViewStatus
{
    WJFooterViewStatusBeginDrag,
    WJFooterViewStatusDragging,
    WJFooterViewStatusLoading
};

typedef enum FooterViewStatus WJFooterViewStatus;

@protocol WJFooterViewDelegate <NSObject>

-(void)footerViewWithStatus:(WJFooterView *)footerView status:(WJFooterViewStatus)status;

@end

@interface WJFooterView : UIView

@property (nonatomic,weak) id<WJFooterViewDelegate> delegate;



@property (nonatomic,assign) WJFooterViewStatus status;

-(void)stopAnimation;

+(id)footerView;

//重写按钮的setTitle: forState:方法 ,把状态改成WJFooterViewStatus
-(void)setTitle:(NSString *)title forState:(WJFooterViewStatus)status;

@end
