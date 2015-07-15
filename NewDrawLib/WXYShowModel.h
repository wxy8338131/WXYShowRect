//
//  WXYHTTPViewModel.h
//  NewDraw
//
//  Created by wangxinyu on 15/7/6.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WXYShowModel : NSObject
/**
 *  上行颜色
 */
@property (nonatomic, weak) UIColor *upLoadColor;
/**
 *  下行颜色
 */
@property (nonatomic, weak) UIColor *downLoadColor;
/**
 *  横向显示多少个点
 */
@property (nonatomic, assign) CGFloat widthNum;
/**
 *  纵向显示多少个点
 */
@property (nonatomic, assign) CGFloat lengthNum;
/**
 *  表格的Frame
 */
@property (nonatomic, assign) CGRect frame;

@end
