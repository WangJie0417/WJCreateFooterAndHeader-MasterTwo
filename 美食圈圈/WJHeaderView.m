//
//  WJHeaderView.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WJHeaderView.h"

@interface WJHeaderView()

//添加一个UIButton
@property (nonatomic,weak) UIButton * alertButton;

//添加一个UIView
@property (nonatomic,weak) UIView * loadingView;

@property (nonatomic,weak) UIScrollView *scrollView;

@end



@implementation WJHeaderView
{
    NSString * _beginDragText;
    NSString * _draggingText;
    NSString * _loadingText;
}

-(void)setTitle:(NSString *)title forState:(WJHeaderViewStatus)status
{
    switch (status)
    {
        case WJHeaderViewStatusBeginDrag:
            _beginDragText = title;
            break;
            
        case WJHeaderViewStatusDragging:
            _draggingText = title;
            break;
            
        case WJHeaderViewStatusLoading:
            _loadingText = title;
            break;
            
        default:
            break;
    }
}

-(NSString *)titleWithStatus:(WJHeaderViewStatus)status
{
    NSString *title = nil;
    
    switch (status) {
        case WJHeaderViewStatusBeginDrag:
            title = _beginDragText?_beginDragText:@"拖拽";
            break;
            
        case WJHeaderViewStatusDragging:
            title = _draggingText?_draggingText:@"松开";
            break;
            
        case WJHeaderViewStatusLoading:
            title = _loadingText?_loadingText:@"加载";
            break;
            
        default:
            break;
    }
    return title;
}

-(void)stopAnimation
{
    //1.
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //2.移除当前显示的这个footerView
    [self clear];
}

-(void)clear
{
    [self.alertButton removeFromSuperview];
    [self.loadingView removeFromSuperview];
    self.status = WJHeaderViewStatusBeginDrag;
}

-(void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)setScrollView:(UIScrollView *)scrollView
{
    //1.移除旧的
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    //2.保存成员变量
    _scrollView = scrollView;
    //3.添加新的监听
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //当为loading时不再往下执行
    if (self.status == WJHeaderViewStatusLoading) return;
    
    
    [self willMoveToSuperview:self.scrollView];
    
    //在拖拽的时候就判断是拖拽加载更多还是松开加载更多
    if (self.scrollView.isDragging)
    {
        //拖到底部了，而且在一定区间内显示“开始拖拽加载更多”
        if (_scrollView.contentOffset.y < 0 && _scrollView.contentOffset.y >= -40)
        {
            self.status = WJHeaderViewStatusBeginDrag;
        }
        else if (_scrollView.contentOffset.y < -40 && _scrollView.contentOffset.y >= -60)
        {
            self.status = WJHeaderViewStatusDragging;
        }
        
    }
    
    
    //不是拖拽的时候就要判断是哪种状态，然后设置状态
    else
    {
        if (self.status == WJHeaderViewStatusDragging)
        {
            self.status = WJHeaderViewStatusLoading;
            _scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
            
            [_delegate headerViewWithStatus:self status:WJHeaderViewStatusLoading];
        }
    }
    
}


-(UIView *)loadingView
{
    if(_loadingView == nil)
    {
        UIView *loadingView = [UIView new];
        [self addSubview:loadingView];
        _loadingView = loadingView;
        
        loadingView.frame = self.bounds;
        
        //添加子控件
        
        UILabel *loadLabel = [UILabel new];
        [loadingView addSubview:loadLabel];
        
        loadLabel.frame = loadingView.bounds;
        loadLabel.textColor = [UIColor blackColor];
        loadLabel.font = [UIFont systemFontOfSize:15];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.text = [self titleWithStatus:WJHeaderViewStatusLoading];
        //_loadingText;//@"努力加载...";
        
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [loadingView addSubview:activity];
        activity.frame = CGRectMake(100, 20, 20, 20);
        [activity startAnimating];
    }
    return _loadingView;
}

-(UIButton *)alertButton
{
    if(_alertButton == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        _alertButton = btn;
        
        btn.frame = self.bounds;
        [btn setImage:[UIImage imageNamed:@"arrow@2x.png"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return _alertButton;
}




-(void)setStatus:(WJHeaderViewStatus)status
{
    _status = status;
    
    switch (status) {
        case WJHeaderViewStatusBeginDrag:
            [self.alertButton setTitle:[self titleWithStatus:WJHeaderViewStatusBeginDrag] forState:UIControlStateNormal];
            break;
            
        case WJHeaderViewStatusDragging:
            [self.alertButton setTitle:[self titleWithStatus:WJHeaderViewStatusDragging] forState:UIControlStateNormal];
            break;
            
        case WJHeaderViewStatusLoading:
            self.alertButton.hidden = YES;
            self.loadingView;
            break;

            
        default:
            break;
    }
}

+(id)headerView
{
    return [[self alloc]init];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    UITableView *tableView = (UITableView *)newSuperview;
    
    CGFloat selfX = 0;
    CGFloat selfY = -60;
    CGFloat selfW = tableView.contentSize.width;
    CGFloat selfH = 60;
    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
    
    self.backgroundColor = [UIColor yellowColor];
}

-(void)didMoveToSuperview
{
    self.scrollView = (UIScrollView *)self.superview;
}

@end
