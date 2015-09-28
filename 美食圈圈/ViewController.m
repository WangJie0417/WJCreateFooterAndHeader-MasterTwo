//
//  ViewController.m
//  美食圈圈
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "WJSubject.h"
#import "NSArray+desc.h"
#import "WJSubjectCell.h"
#import "WJFooterView.h"
#import "WJContentView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *plist;
@property (nonatomic,strong) NSArray *subjectArray;

@end



@implementation ViewController

-(NSArray *)plist
{
    if(_plist == nil)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"quanquan.plist" ofType:nil];
        NSArray *tmp = [NSArray arrayWithContentsOfFile:path];
        _plist = tmp;
    }
    return _plist;
}

-(NSArray *)subjectArray
{
    if(_subjectArray == nil)
    {
        //1.plist
        NSArray * dicts = self.plist[1];
    
        //2.封装模型
        NSMutableArray * objs = [NSMutableArray array];
        for (NSDictionary * dict in dicts) {
            WJSubject * subject = [WJSubject subjectWithDict:dict];
            [objs addObject:subject];
        }
        
        _subjectArray = objs;
    }
    return _subjectArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    WJContentView *contentView = [WJContentView contentView];
    [self.view addSubview:contentView];
    contentView.subjectArray = self.subjectArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
