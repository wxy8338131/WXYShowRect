//
//  WXYHTTPViewModel.m
//  NewDraw
//
//  Created by wangxinyu on 15/7/6.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "WXYShowModel.h"

@implementation WXYShowModel

- (void)setUpLoadColor:(UIColor *)upLoadColor
{
    if (!upLoadColor) {
        upLoadColor = [UIColor blueColor];
    }
    _upLoadColor = upLoadColor;
}

- (void)setDownLoadColor:(UIColor *)downLoadColor
{
    if (!downLoadColor) {
        downLoadColor = [UIColor greenColor];
    }
    _downLoadColor = downLoadColor;
}

- (void)setWidthNum:(CGFloat)widthNum
{
    if (!widthNum) {
        widthNum = 100.0f;
    }
    _widthNum = widthNum;
}

- (void)setLengthNum:(CGFloat)lengthNum
{
    if (!lengthNum) {
        lengthNum = 80.0f;
    }
    _lengthNum = lengthNum;
}

- (void)setFrame:(CGRect)frame
{
    if (!frame.size.width || !frame.size.height) {
        frame = CGRectMake(10, 100, [UIScreen mainScreen].bounds.size.width - 20, 200);
    }
    _frame = frame;
}


@end
