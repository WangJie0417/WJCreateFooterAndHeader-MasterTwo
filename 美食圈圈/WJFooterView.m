//
//  WJFooterView.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WJFooterView.h"

@interface WJFooterView()

//添加一个UIButton
@property (nonatomic,weak) UIButton * alertButton;

//添加一个UIView
@property (nonatomic,weak) UIView * loadingView;


@property (nonatomic,weak) UIScrollView *scrollView;

@end

@implementation WJFooterView
{
    NSString * _beginDragText;
    NSString * _draggingText;
    NSString * _loadingText;
}

-(void)setTitle:(NSString *)title forState:(WJFooterViewStatus)status
{
    switch (status)
    {
        case WJFooterViewStatusBeginDrag:
            _beginDragText = title;
            break;
            
        case WJFooterViewStatusDragging:
            _draggingText = title;
            break;
            
        case WJFooterViewStatusLoading:
            _loadingText = title;
            break;
            
        default:
            break;
    }
}

-(NSString *)titleWithStatus:(WJFooterViewStatus)status
{
    NSString *title = nil;
    
    switch (status) {
        case WJFooterViewStatusBeginDrag:
            title = _beginDragText?_beginDragText:@"拖拽";
            break;
            
        case WJFooterViewStatusDragging:
            title = _draggingText?_draggingText:@"松开";
            break;
            
        case WJFooterViewStatusLoading:
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
    self.status = WJFooterViewStatusBeginDrag;
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
    if (self.status == WJFooterViewStatusLoading) return;
    
    
    [self willMoveToSuperview:self.scrollView];
    
    //在拖拽的时候就判断是拖拽加载更多还是松开加载更多
    if (self.scrollView.isDragging)
    {
        CGFloat maxY = _scrollView.contentSize.height - _scrollView.frame.size.height;
        CGFloat footerViewHeight = self.frame.size.height;
        //拖到底部了，而且在一定区间内显示“开始拖拽加载更多”
        if (_scrollView.contentOffset.y >= maxY && _scrollView.contentOffset.y < maxY+footerViewHeight)
        {
            self.status = WJFooterViewStatusBeginDrag;
        }
        else if (_scrollView.contentOffset.y > maxY+footerViewHeight)
        {
            self.status = WJFooterViewStatusDragging;
        }

    }
    
    //不是拖拽的时候就要判断是哪种状态，然后设置状态
    else
    {
        if (self.status == WJFooterViewStatusDragging)
        {
            self.status = WJFooterViewStatusLoading;
            _scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.frame.size.height, 0);
            [_delegate footerViewWithStatus:self status:WJFooterViewStatusLoading];
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
        loadLabel.text = [self titleWithStatus:WJFooterViewStatusLoading];
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

+(id)footerView
{
    return [[self alloc] init];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    //1.添加到哪里？
    UITableView * tableView = (UITableView *)newSuperview;
    //2.添加到什么位置？
    CGFloat selfX = 0;
    CGFloat selfY = tableView.contentSize.height;
    CGFloat selfW = tableView.frame.size.width;
    CGFloat selfH = 60;//可动态获取
    
    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
    self.backgroundColor = [UIColor yellowColor];
    
    
}

-(void)didMoveToSuperview
{
    //父视图(tableView)出现之后，才能计算contentSize的大小
    self.scrollView = (UITableView *)self.superview;
}
-(void)setStatus:(WJFooterViewStatus)status
{
    _status = status;
    
    switch (status) {
        case WJFooterViewStatusBeginDrag:
            [self.alertButton setTitle:[self titleWithStatus:WJFooterViewStatusBeginDrag] forState:UIControlStateNormal];
            break;
            
        case WJFooterViewStatusDragging:
            [self.alertButton setTitle:[self titleWithStatus:WJFooterViewStatusDragging] forState:UIControlStateNormal];
            break;
            
        case WJFooterViewStatusLoading:
            self.alertButton.hidden = YES;
            self.loadingView;
            break;
            
        default:
            break;
    }
}
/*
//因为tableView也是scrollView,所以也可以重写下面的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //怎么判断已经滚动到了底部
    //UIScrollView 的最大偏移量是多少？
    CGFloat maxY = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //拖到底部了，而且在一定区间内显示“开始拖拽加载更多”
    if (scrollView.contentOffset.y >= maxY && scrollView.contentOffset.y <= maxY+60)
    {
        self.footerView.status = WJFooterViewStatusBeginDrag;
    }
    else if (scrollView.contentOffset.y > maxY+60)
    {
        self.footerView.status = WJFooterViewStatusDragging;
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.footerView.status == WJFooterViewStatusDragging) {
        self.footerView.status = WJFooterViewStatusLoading;
    }
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.footerView.frame.size.height, 0);
    
}
*/
@end
