//
//  WJContentView.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "WJContentView.h"
#import "WJSubjectCell.h"
#import "WJFooterView.h"
#import "WJHeaderView.h"

@interface WJContentView()<WJFooterViewDelegate,WJHeaderViewDelegate>

@property (nonatomic,weak) WJFooterView *footerView;
@property (nonatomic,strong) WJHeaderView *headerView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WJContentView



-(void)setSubjectArray:(NSArray *)subjectArray
{
    _subjectArray = subjectArray;
    
    [self.tableView reloadData];
}

//懒加载

//-(WJHeaderView *)headerView
//{
//    if (_headerView == nil)
//    {
//        WJHeaderView *headerView = [WJHeaderView headerView];
//        [self.tableView addSubview:headerView];
//        
//        _headerView = headerView;
//    }
//    return _headerView;
//}
//-(WJFooterView *)footerView
//{
//    if(_footerView == nil)
//    {
//        WJFooterView *footerView = [WJFooterView footerView];
//        [self.tableView addSubview:footerView];
//        _footerView = footerView;
//    }
//    return _footerView;
//}

//当self对象是从xib文件加载而来的时候，会调用这个方法，并且只调用一次
//创建一些子控件。设置改变一些控件的属性
-(void)awakeFromNib
{
    //1.添加上拉加载视图
    
    WJFooterView * footerView = [WJFooterView footerView];
    
    [self.tableView addSubview:footerView];
    _footerView = footerView;
    footerView.delegate = self;
    
    [footerView setTitle:@"拖拽加载更多。。。" forState:WJFooterViewStatusBeginDrag];
    [footerView setTitle:@"松开加载更多。。。" forState:WJFooterViewStatusDragging];
    [footerView setTitle:@"开始加载。。。" forState:WJFooterViewStatusLoading];
    
    
    //2.添加下拉刷新视图
    
    WJHeaderView * headerView = [WJHeaderView headerView];
    [self.tableView addSubview:headerView];
    _headerView = headerView;
    headerView.delegate = self;
    
    [headerView setTitle:@"下拉刷新更多。。。" forState:WJHeaderViewStatusBeginDrag];
    [headerView setTitle:@"松开刷新更多。。。" forState:WJHeaderViewStatusDragging];
    [headerView setTitle:@"开始刷新。。。" forState:WJHeaderViewStatusLoading];
    
}

+(id)contentView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.bounds;
    
    self.backgroundColor = [UIColor yellowColor];
    
}

#pragma mark - 代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subjectArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WJSubjectCell * cell = [WJSubjectCell subjectCellWithTableView:tableView];
    cell.subject = self.subjectArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.footerView removeFromSuperview];
//    [self.footerView stopAnimation];
    
    //[self.headerView stopAnimation];
}
#pragma mark - WJFooterViewDelegate方法
//实现下面的代理方法作用：可以设置多少秒后加载完毕，而不是需要点击cell才停止加载
-(void)footerViewWithStatus:(WJFooterView *)footerView status:(WJFooterViewStatus)status
{
    NSLog(@"开始网络请求");
    [self performSelector:@selector(sendRequestWithFooterVeiw) withObject:nil afterDelay:5];
    
}
-(void)sendRequestWithFooterVeiw
{
    NSLog(@"网络请求结束");
    [self.footerView stopAnimation];
}

#pragma mark - WJHeaderViewDelegate方法
-(void)headerViewWithStatus:(WJHeaderView *)header status:(WJHeaderViewStatus)status
{
    NSLog(@"开始网络请求");
    [self performSelector:@selector(sendRequestWithHeaderView) withObject:nil afterDelay:5];
}
-(void)sendRequestWithHeaderView
{
    NSLog(@"网络请求结束");
    [self.headerView stopAnimation];
}

/*
//因为tableView也是scrollView,所以也可以重写下面的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //怎么判断已经开始拖动
    //UIScrollView 向下拉
//    CGFloat maxY = scrollView.contentSize.height - scrollView.frame.size.height;
    
    //拖到底部了，而且在一定区间内显示“开始拖拽加载更多”
    if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y >= -40)
    {
        self.headerView.status = WJHeaderViewStatusBeginDrag;
    }
    else if (scrollView.contentOffset.y < -40 && scrollView.contentOffset.y >= -60)
    {
        self.headerView.status = WJHeaderViewStatusDragging;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.headerView.status == WJHeaderViewStatusDragging) {
        self.headerView.status = WJHeaderViewStatusLoading;
        }
    scrollView.contentInset = UIEdgeInsetsMake(self.headerView.frame.size.height, 0, 0, 0);
}
*/

@end
