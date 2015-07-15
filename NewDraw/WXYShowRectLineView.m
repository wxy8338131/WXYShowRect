//
//  LineView.m
//  NewDraw
//
//  Created by wangxinyu on 15-1-13.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "WXYShowRectLineView.h"


@interface WXYShowRectLineView ()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *downArray;

@property (nonatomic, strong) NSMutableArray *upLoadArray;

@property (nonatomic, strong) NSMutableArray *allDownArray;

@property (nonatomic, strong) NSMutableArray *allUpLoadArray;

@property (nonatomic, assign) CGFloat hengNumber;

@property (nonatomic, assign) CGFloat zongNumber;

@end

@implementation WXYShowRectLineView

- (void)setModel:(WXYShowModel *)model
{
    _model = model;
    
    self.hengNumber = model.widthNum;
    self.zongNumber = model.lengthNum;
    
    // 1. 设置背景颜色为透明
    self.backgroundColor = [UIColor clearColor];
    
    // 2. 设置横向纵向的距离
    self.width = self.frame.size.width / self.hengNumber;
    self.height = self.frame.size.height / self.zongNumber;
    
}

/**
 *  httpDownLoad  set方法
 */
- (void)setHttpDownLoad:(int)httpDownLoad
{
    _httpDownLoad = httpDownLoad;
    
    int downLoadNum = httpDownLoad;
    
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    downLoadNum = self.frame.size.height - downLoadNum * zong;
    
    // 1. 将每次获取的下载速度添加到数组
    [self.downArray addObject:[NSNumber numberWithInt:downLoadNum]];
    
    // 2. 刷新绘画图层
    [self setNeedsDisplay];
    
}
/**
 *  httpUpLoad  set方法
 */
- (void)setHttpUpLoad:(int)httpUpLoad
{
    _httpUpLoad = httpUpLoad;
    
    int UpLoadNum = httpUpLoad;
    
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    UpLoadNum = self.frame.size.height - UpLoadNum * zong;
    
    // 1. 将每次获取的上传速度添加到数组
    [self.upLoadArray addObject:[NSNumber numberWithInt:UpLoadNum]];
    
    // 2. 刷新绘画图层
    [self setNeedsDisplay];
    
}
/**
 *  绘制图层
 */
- (void)drawRect:(CGRect)rect
{
    if (self.upLoadArray.count) {
        [self addUpLoadLine];
    }
    if (self.downArray.count) {
        [self addDownLoadLine];
    }
    if (self.allDownArray.count) {
        [self addDownLoadLineWithArray:self.allDownArray];
    }
    if (self.allUpLoadArray.count) {
        [self addUpLoadLineWithArray:self.allUpLoadArray];
    }
    
}
/**
 *  绘制下行线段
 */
- (void)addDownLoadLine
{
    // 1. 判断，如果超过横线标准，那么删除数组第一个元素，其余元素统一向前移位
    if (self.downArray.count > self.hengNumber + 1) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.downArray.count; i++) {
            if (i != 0) {
                NSNumber *num = [self.downArray objectAtIndex:i];
                [tempArray addObject:num];
            }
        }
        // 1.1 清空并赋值
        [self.downArray removeAllObjects];
        self.downArray = [NSMutableArray arrayWithArray:tempArray];
        // 1.2 干掉临时数组，防止野指针出现
        [tempArray removeAllObjects];
        tempArray = nil;
    }
    
    // 2. 实例化贝塞尔曲线，并且设置基本属性
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 0.5f;
    
    // 3. 循环取出数组中的坐标，画线
    for (int i = 0; i<self.downArray.count; i++) {
        CGFloat y = [[self.downArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * self.width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else{
            [bezierPath addLineToPoint:point];
        }
    }
    // 4. 设置颜色，结束绘画
    [self.model.downLoadColor set];
    [bezierPath stroke];
    
}
/**
 *  绘制上行线段
 */
- (void)addUpLoadLine
{
    // 1. 判断，如果超过横线标准，那么删除数组第一个元素，其余元素统一向前移位
    if (self.upLoadArray.count > self.hengNumber + 1) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.upLoadArray.count; i++) {
            if (i != 0) {
                NSNumber *num = [self.upLoadArray objectAtIndex:i];
                [tempArray addObject:num];
            }
        }
        // 1.1 清空并赋值
        [self.upLoadArray removeAllObjects];
        self.upLoadArray = [NSMutableArray arrayWithArray:tempArray];
        // 1.2 干掉临时数组，防止野指针出现
        [tempArray removeAllObjects];
        tempArray = nil;
    }
    
    // 2. 实例化贝塞尔曲线，并且设置基本属性
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 0.5f;
    
    // 3. 循环取出数组中的坐标，画线
    for (int i = 0; i<self.upLoadArray.count; i++) {
        CGFloat y = [[self.upLoadArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * self.width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else{
            [bezierPath addLineToPoint:point];
        }
    }
    // 4. 设置颜色，结束绘画
    [self.model.upLoadColor set];
    [bezierPath stroke];

}

#pragma mark - 根据数组显示历史线段
/**
 *  根据数组 在静态图片状态显示所有下载线段
 */
- (void)showAllDownLoadNumWithArray:(NSArray *)allDownLoadArray
{
    // 1. 获取纵向总点数，拿到比例
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    int number;
    [self.allDownArray removeAllObjects];
    for (NSNumber *num in allDownLoadArray) {
        // 2. 循环取出每一个数组中的元素，按比例计算位置
        number = self.frame.size.height - [num intValue] * zong;
        [self.allDownArray addObject:@(number)];
    }
    [self setNeedsDisplay];
}
- (void)addDownLoadLineWithArray:(NSArray *)allDownLoadArray
{
    // 1. 实例化贝塞尔曲线，并且设置基本属性
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 0.5f;
    
    // 2. 设置横向显示所有线段
    CGFloat width = self.frame.size.width / allDownLoadArray.count;
    
    // 3. 循环取出数组中的坐标，画线
    for (int i = 0; i < allDownLoadArray.count; i++) {
        CGFloat y = [[allDownLoadArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else{
            [bezierPath addLineToPoint:point];
        }
    }
    // 4. 设置颜色，结束画线
    [self.model.downLoadColor set];
    [bezierPath stroke];
    
    // 5. 清空数组，防止野指针出现
    [self.allDownArray removeAllObjects];
    self.allDownArray = nil;
}
/**
 *  根据数组 在静态图片状态显示所有上传线段
 */
- (void)showAllUpLoadNumWithArray:(NSArray *)allUpLoadArray
{
    // 1. 获取纵向总点数，拿到比例
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    int number;
    [self.allUpLoadArray removeAllObjects];
    for (NSNumber *num in allUpLoadArray) {
        // 2. 循环取出每一个数组中的元素，按比例计算位置
        number = self.frame.size.height - [num intValue] * zong;
        [self.allUpLoadArray addObject:@(number)];
    }
    [self setNeedsDisplay];
}

- (void)addUpLoadLineWithArray:(NSArray *)allUpLoadArray
{
    // 1. 实例化贝塞尔曲线，并且设置基本属性
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 0.5f;
    
    // 2. 设置横向显示所有线段
    CGFloat width = self.frame.size.width / allUpLoadArray.count;
    
    // 3. 循环取出数组中的坐标，画线
    for (int i = 0; i < allUpLoadArray.count; i++) {
        CGFloat y = [[allUpLoadArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else{
            [bezierPath addLineToPoint:point];
        }
    }
    // 4. 设置颜色，结束画线
    [self.model.upLoadColor set];
    [bezierPath stroke];
    
    // 5. 清空数组，防止野指针出现
    [self.allUpLoadArray removeAllObjects];
    self.allUpLoadArray = nil;
}


#pragma mark - 懒加载

- (NSMutableArray *)downArray
{
    if (!_downArray) {
        _downArray = [NSMutableArray array];
    }
    return _downArray;
}

- (NSMutableArray *)upLoadArray
{
    if (!_upLoadArray) {
        _upLoadArray = [NSMutableArray array];
    }
    return _upLoadArray;
}

- (NSMutableArray *)allUpLoadArray
{
    if (!_allUpLoadArray) {
        _allUpLoadArray = [NSMutableArray array];
    }
    return _allUpLoadArray;
}

- (NSMutableArray *)allDownArray
{
    if (!_allDownArray) {
        _allDownArray = [NSMutableArray array];
    }
    return _allDownArray;
}
@end
