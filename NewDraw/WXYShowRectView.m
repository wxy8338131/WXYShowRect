//
//  WXYHTTPView.m
//  NewDraw
//
//  Created by wangxinyu on 15-1-13.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "WXYShowRectView.h"
#import "WXYShowRectBGView.h"
#import "WXYChangeGraduallyDownView.h"
#import "WXYChangeGraduallyUpView.h"
#import "WXYShowRectLineView.h"

#import "WXYShowModel.h"

@interface WXYShowRectView ()

@property (nonatomic, strong) WXYShowRectBGView *pictureView;

@property (nonatomic, strong) WXYChangeGraduallyDownView *downLoadView;

@property (nonatomic, strong) WXYChangeGraduallyUpView *upLoadView;

@property (nonatomic, strong) WXYShowRectLineView *lineView;

@end


@implementation WXYShowRectView


#pragma mark -- 两种初始化方式 -- 😈

- (void)showRectWithModel:(WXYShowModel *)model
{
    // 0. 设置自己的frame
    self.frame = model.frame;
    
    // 1. 初始化 表格 坐标
    WXYShowRectBGView *pic = [[WXYShowRectBGView alloc] initWithFrame:self.bounds];
    pic.model = model;
    [self addSubview:pic];
    self.pictureView = pic;
    
    // 2. 初始化 上传渐变 坐标
    WXYChangeGraduallyUpView *upLoad = [[WXYChangeGraduallyUpView alloc] initWithFrame:self.bounds];
    upLoad.model = model;
    [self addSubview:upLoad];
    self.upLoadView = upLoad;
    
    // 3. 初始化 下载渐变 坐标
    WXYChangeGraduallyDownView *downLoad = [[WXYChangeGraduallyDownView alloc] initWithFrame:self.bounds];
    downLoad.model = model;
    [self addSubview:downLoad];
    self.downLoadView = downLoad;
    
    // 4. 初始化 线段 坐标
    WXYShowRectLineView *line = [[WXYShowRectLineView alloc] initWithFrame:self.bounds];
    line.model = model;
    [self addSubview:line];
    self.lineView = line;
}

/**
 *  httpDownLoad  set方法
 */
- (void)setHttpDownLoad:(int)httpDownLoad
{
    _httpDownLoad = httpDownLoad;
    // 1. 给渐变图层传值
    self.lineView.httpDownLoad = self.httpDownLoad;
    // 2. 给线段图层传值
    self.downLoadView.httpDownLoad = self.httpDownLoad;
    
}
/**
 *  httpUpLoad  set方法
 */
- (void)setHttpUpLoad:(int)httpUpLoad
{
    _httpUpLoad = httpUpLoad;
    // 1. 给渐变图层传值
    self.lineView.httpUpLoad = self.httpUpLoad;
    // 2. 给线段图层传值
    self.upLoadView.httpUpLoad = self.httpUpLoad;
}


/**
 *  显示总下载速度的表格
 *
 *  @param allDownLoadArray 下载速度数组
 */
- (void)showDownLoadNumsWithArray:(NSArray *)allDownLoadArray
{
    // 1. 绘画渐变图层
    [self.downLoadView showAllDownLoadNumWithArray:allDownLoadArray];
    // 2. 绘画出线段图层
    [self.lineView showAllDownLoadNumWithArray:allDownLoadArray];
}
/**
 *  显示总上传速度的表格
 *
 *  @param allUpLoadArray 上传速度数组
 */
- (void)showUpLoadNumsWithArray:(NSArray *)allUpLoadArray
{
    // 1. 绘画渐变图层
    [self.upLoadView showAllUpLoadNumWithArray:allUpLoadArray];
    // 2. 绘画出线段图层
    [self.lineView showAllUpLoadNumWithArray:allUpLoadArray];
}

/**
 *  上下行速率同时显示在一张表上
 *
 *  @param allDownLoadArray 下行总数组
 *  @param allUpLoadArray   上行总数组
 */
- (void)showAllSpeedWithDownLoadArray:(NSArray *)DownArray upLoadArray:(NSArray *)UpArray
{
    // 1. 绘画渐变图层
    [self.downLoadView showAllDownLoadNumWithArray:DownArray];
    [self.upLoadView showAllUpLoadNumWithArray:UpArray];
    // 2. 绘画出线段图层
    [self.lineView showAllUpLoadNumWithArray:UpArray];
    [self.lineView showAllDownLoadNumWithArray:DownArray];
}


@end
