//
//  LineView.m
//  NewDraw
//
//  Created by wangxinyu on 15-1-12.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "WXYChangeGraduallyDownView.h"
#import <QuartzCore/QuartzCore.h>
#import "WXYShowModel.h"

@interface WXYChangeGraduallyDownView ()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *downArray;

@property (nonatomic, assign) CGFloat hengNumber;

@property (nonatomic, assign) CGFloat zongNumber;

@end

#define HengNumber 100

#define ZongNumber 80

@implementation WXYChangeGraduallyDownView

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
    // 生成一个绿色透明色的背景
    [self setupDownLoadMulticolor];
    // 生产一个圆形路径并设置成遮罩
    self.layer.mask = [self produceDownLoadShapeLayer];
    
}


/**
 *  httpDownLoad  set方法
 */
- (void)setHttpDownLoad:(int)httpDownLoad
{
    _httpDownLoad = httpDownLoad;
    
    int downLoadNum = httpDownLoad;
    
    // 如果传入为10，直接话 是从上面的0到10，但是我们是下面0上面100，所以要换算一下
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    downLoadNum = self.frame.size.height - downLoadNum * zong;
    
    // 1. 将每次获取的下载速度添加到数组
    [self.downArray addObject:[NSNumber numberWithInt:downLoadNum]];
    
    // 2. 设置要展示出来的带路径的遮罩
    self.layer.mask = [self produceDownLoadShapeLayer];
    
    
}
/**
 *  生成一个“蓝色和透明色”的背景图片
 */
- (void)setupDownLoadMulticolor
{
    // 1. 创建一个新图层
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.bounds;
    
    // 2. 设置颜色线条分布的方向
    gradientLayer.startPoint = CGPointMake(0.0, -0.3);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    
    // 3. 创建颜色数组方法1
//    NSMutableArray *colors = [NSMutableArray array];
//    for (NSInteger hue = 0; hue <= 360; hue += 10) {
//        [colors addObject:(id)[UIColor colorWithHue:1.0*hue/360.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor];
//    }
    //62,163,219
//    UIColor *cooo = [UIColor colorWithRed:227 / 255.0 green:1 / 255.0 blue:117 / 255.0 alpha:1];
//    NSArray *colorsArray = [NSArray arrayWithObjects:(id)cooo.CGColor,(id)[UIColor clearColor].CGColor, nil];
//    [gradientLayer setColors:[NSArray arrayWithArray:colorsArray]];
    
    // 3. 创建颜色数组方法2

    NSArray *colorsArray = [NSArray arrayWithObjects:(id)self.model.downLoadColor.CGColor,(id)[UIColor clearColor].CGColor, nil];
    [gradientLayer setColors:[NSArray arrayWithArray:colorsArray]];
    
    // 4. 将新图层添加到自身的图层上
    [self.layer addSublayer:gradientLayer];
    
}
/**
 *  绘制遮罩
 */
- (CAShapeLayer *)produceDownLoadShapeLayer
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
    bezierPath.lineWidth = 1.0f;
    
    // 3. 循环取出数组中的坐标，画线
    for (int i = 0; i<self.downArray.count; i++) {
        CGFloat y = [[self.downArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * self.width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else if (i == self.downArray.count - 1){
            [bezierPath addLineToPoint:point];
            [bezierPath addLineToPoint:CGPointMake(i * self.width, self.frame.size.height)];
            [bezierPath addLineToPoint:CGPointMake(0.0, self.frame.size.height)];
            [bezierPath closePath];
            
        }else{
            [bezierPath addLineToPoint:point];
        }
        
    }
    // 4. 创建一个遮罩，路径为上面贝塞尔曲线路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = 2;
    
    
    // 5. 返回遮罩，就是要显示出来的位置
    return shapeLayer;
}



#pragma mark - 根据数组显示历史下载填充图

/**
 *  根据数组 在静态图片状态显示所有下载曲线填充图
 */
- (void)showAllDownLoadNumWithArray:(NSArray *)allDownLoadArray
{
    // 1. 获取纵向总点数，拿到比例
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    int number;
    NSMutableArray *tempArry = [NSMutableArray array];
    for (NSNumber *num in allDownLoadArray) {
        // 2. 循环取出每一个数组中的元素，按比例计算位置
        number = self.frame.size.height - [num intValue] * zong;
        [tempArry addObject:@(number)];
    }
    // 生产一个路径并设置成遮罩
    self.layer.mask = [self produceDownLoadArray:tempArry];
    [tempArry removeAllObjects];
    tempArry = nil;
}
/**
 *  绘制遮罩
 */
- (CAShapeLayer *)produceDownLoadArray:(NSArray *)allDownLoadArray
{
    // 1. 实例化贝塞尔曲线，并且设置基本属性
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 1.0f;
    
    // 2. 设置横向显示所有线段
    CGFloat width = self.frame.size.width / allDownLoadArray.count;
    
    // 3. 循环取出数组中的坐标，画线线
    for (int i = 0; i < allDownLoadArray.count; i++) {
        CGFloat y = [[allDownLoadArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else if (i == allDownLoadArray.count - 1){
            [bezierPath addLineToPoint:point];
            [bezierPath addLineToPoint:CGPointMake(i * width, self.frame.size.height)];
            [bezierPath addLineToPoint:CGPointMake(0.0, self.frame.size.height)];
            [bezierPath closePath];
            
        }else{
            [bezierPath addLineToPoint:point];
        }
        
    }
    // 4. 创建一个遮罩，路径为上面贝塞尔曲线路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.lineWidth = 2;
    
    // 5. 返回遮罩，就是要显示出来的位置
    return shapeLayer;
}

#pragma mark - 懒加载

- (NSMutableArray *)downArray
{
    if (!_downArray) {
        _downArray = [NSMutableArray array];
    }
    return _downArray;
}

@end
