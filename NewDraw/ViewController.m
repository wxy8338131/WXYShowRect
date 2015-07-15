//
//  ViewController.m
//  NewDraw
//
//  Created by wangxinyu on 15-1-12.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "ViewController.h"
#import "WXYShowRectView.h"
#import "WXYShowModel.h"

@interface ViewController ()

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, strong) WXYShowRectView *showView;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    // 1. 创建显示历史记录按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(80, [UIScreen mainScreen].bounds.size.height / 2, [UIScreen mainScreen].bounds.size.width - 150, 50);
    [btn setTitle:@"展示150秒历史记录" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor yellowColor]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 实例化视图对象
    WXYShowRectView *showView = [[WXYShowRectView alloc] init];
    
    // 2. 配置参数模型
    WXYShowModel *model = [[WXYShowModel alloc] init];
    model.upLoadColor = [UIColor blueColor];
    model.downLoadColor = [UIColor greenColor];
    model.widthNum = 100;
    model.lengthNum = 100;
    model.frame = CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
    // 3. 展示视图
    [showView showRectWithModel:model];
    [self.view addSubview:showView];
    self.showView = showView;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeUpData) userInfo:nil repeats:YES];
}

- (void)timeUpData
{
    int number = arc4random() % 20 + 60;
    int number2 = arc4random() % 30 + 10;
    
    self.showView.httpDownLoad = number;
    self.showView.httpUpLoad = number2;
}

- (void)btnDidClicked
{
    // 1. 实例化视图对象// 1. 实例化视图对象
    WXYShowRectView *showView = [[WXYShowRectView alloc] init];
    
    // 2. 配置参数模型
    WXYShowModel *model = [[WXYShowModel alloc] init];
    model.upLoadColor = [UIColor blueColor];
    model.downLoadColor = [UIColor greenColor];
    model.widthNum = 150;
    model.lengthNum = 100;
    model.frame = CGRectMake(10, 350, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
    // 3. 展示视图
    [showView showRectWithModel:model];
    
    [self.view addSubview:showView];
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array1 = [NSMutableArray array];
    int number;
    int number2;
    for (int i = 0; i < 150; i++) {
        number = arc4random() % 20 + 60;
        [array addObject:@(number)];
    }
    for (int i = 0; i < 150; i++) {
        number2 = arc4random() % 30 + 10;
        [array1 addObject:@(number2)];
    }
    
    [showView showAllSpeedWithDownLoadArray:array upLoadArray:array1];
}





@end
