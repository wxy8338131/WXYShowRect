//
//  WXYHTTPView.h
//  NewDraw
//
//  Created by wangxinyu on 15-1-13.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXYShowModel;

@interface WXYShowRectView : UIView

/**
 *  每秒赋值绘出上传表格
 */
@property (nonatomic, assign) int httpUpLoad;
/**
 *  每秒赋值绘出下载表格
 */
@property (nonatomic, assign) int httpDownLoad;

/**
 *  根据配置参数来绘制表格
 *
 *  @param model 模型
 */
- (void)showRectWithModel:(WXYShowModel *)model;

/**
 *  显示总下载速度的表格
 *
 *  @param allDownLoadArray 下载速度数组
 */
- (void)showDownLoadNumsWithArray:(NSArray *)allDownLoadArray;
/**
 *  显示总上传速度的表格
 *
 *  @param allUpLoadArray 上传速度数组
 */
- (void)showUpLoadNumsWithArray:(NSArray *)allUpLoadArray;

/**
 *  上下行速率同时显示在一张表上
 *
 *  @param allDownLoadArray 下行总数组
 *  @param allUpLoadArray   上行总数组
 */
- (void)showAllSpeedWithDownLoadArray:(NSArray *)DownArray upLoadArray:(NSArray *)UpArray;

@end
