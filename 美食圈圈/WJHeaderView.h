//
//  WJHeaderView.h
//  美食圈圈
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJHeaderView;
enum WJHeaderViewStatus
{
    WJHeaderViewStatusBeginDrag,//下拉刷新更多
    WJHeaderViewStatusDragging,//松开刷新更多
    WJHeaderViewStatusLoading  //正在刷新
};

typedef enum WJHeaderViewStatus WJHeaderViewStatus;

@protocol WJHeaderViewDelegate <NSObject>

-(void)headerViewWithStatus:(WJHeaderView *)header status:(WJHeaderViewStatus)status;

@end

@interface WJHeaderView : UIView

@property (nonatomic,weak) id<WJHeaderViewDelegate> delegate;

@property (nonatomic,assign) WJHeaderViewStatus status;

+(id)headerView;

-(void)stopAnimation;

-(void)setTitle:(NSString *)title forState:(WJHeaderViewStatus)status;

@end
