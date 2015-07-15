//
//  LineView.h
//  NewDraw
//
//  Created by wangxinyu on 15-1-13.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXYShowModel.h"

@interface WXYShowRectLineView : UIView

@property (nonatomic, strong) WXYShowModel *model;

@property (nonatomic, assign) int httpUpLoad;

@property (nonatomic, assign) int httpDownLoad;


- (void)showAllDownLoadNumWithArray:(NSArray *)allDownLoadArray;

- (void)showAllUpLoadNumWithArray:(NSArray *)allUpLoadArray;

@end
