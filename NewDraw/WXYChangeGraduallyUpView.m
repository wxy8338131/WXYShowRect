//
//  UpLoadPicture.m
//  NewDraw
//
//  Created by wangxinyu on 15-1-13.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "WXYChangeGraduallyUpView.h"
#import "WXYShowModel.h"

@interface WXYChangeGraduallyUpView ()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) NSMutableArray *upLoadArray;

@property (nonatomic, assign) CGFloat hengNumber;

@property (nonatomic, assign) CGFloat zongNumber;
@end


@implementation WXYChangeGraduallyUpView

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
    
    // 3. 生成一个绿色透明色的背景
    [self setupUpLoadMulticolor];
    
    // 4. 生产一个圆形路径并设置成遮罩
    self.layer.mask = [self produceUpLoadShapeLayer];
    
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
    
    // 1. 将每次获取的下载速度添加到数组
    [self.upLoadArray addObject:[NSNumber numberWithInt:UpLoadNum]];
    
    // 2. 设置要展示出来的带路径的遮罩
    self.layer.mask = [self produceUpLoadShapeLayer];
}
/**
 *  生成一个“绿色和透明色”的背景图片
 */
- (void)setupUpLoadMulticolor
{
    // 1. 创建一个新图层
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.bounds;
    
    // 2. 设置颜色线条分布的方向
    gradientLayer.startPoint = CGPointMake(0.0, 0.3);
    gradientLayer.endPoint = CGPointMake(0.0, 1.0);
    
    // 3. 创建颜色数组方法1
//    NSMutableArray *colors = [NSMutableArray array];
//    for (NSInteger hue = 0; hue <= 360; hue += 10) {
//        [colors addObject:(id)[UIColor colorWithHue:1.0*hue/360.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor];
//    }
    // 3. 创建颜色数组方法2  227,1,117      62,163,219
//    UIColor *cooo = [UIColor colorWithRed:62 / 255.0 green:163 / 255.0 blue:219 / 255.0 alpha:1];
//    NSArray *colorsArray = [NSArray arrayWithObjects:(id)cooo.CGColor,(id)[UIColor clearColor].CGColor, nil];
//    [gradientLayer setColors:[NSArray arrayWithArray:colorsArray]];
    
    NSArray *colorsArray = [NSArray arrayWithObjects:(id)self.model.upLoadColor.CGColor,(id)[UIColor clearColor].CGColor, nil];
    [gradientLayer setColors:[NSArray arrayWithArray:colorsArray]];
    
    // 4. 将新图层添加到自身的图层上
    [self.layer addSublayer:gradientLayer];
}
/**
 *  绘制遮罩
 */
- (CAShapeLayer *)produceUpLoadShapeLayer
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
    bezierPath.lineWidth = 1.0f;
    
    // 3. 循环取出数组中的坐标，画线
    for (int i = 0; i<self.upLoadArray.count; i++) {
        CGFloat y = [[self.upLoadArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * self.width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else if (i == self.upLoadArray.count - 1){
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
    
    //    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    //    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    // 可以设置出圆的完整性
    //    shapeLayer.strokeStart = 0.0;
    //    shapeLayer.strokeEnd = 1.0;
    
    // 5. 返回遮罩，就是要显示出来的位置
    return shapeLayer;
}



#pragma mark - 根据数组显示历史上传填充图

/**
 *  根据数组 在静态图片状态显示所有上传曲线填充图
 */
- (void)showAllUpLoadNumWithArray:(NSArray *)allUpLoadArray
{
    // 1. 获取纵向总点数，拿到比例
    CGFloat zong = self.frame.size.height / self.model.lengthNum;
    
    int number;
    NSMutableArray *tempArry = [NSMutableArray array];
    for (NSNumber *num in allUpLoadArray) {
        // 2. 循环取出每一个数组中的元素，按比例计算位置
        number = self.frame.size.height - [num intValue] * zong;
        [tempArry addObject:@(number)];
    }
    // 生产一个路径并设置成遮罩
    self.layer.mask = [self produceUpLoadArray:tempArry];
    [tempArry removeAllObjects];
    tempArry = nil;
}
/**
 *  绘制遮罩
 */
- (CAShapeLayer *)produceUpLoadArray:(NSArray *)allUpLoadArray
{
    // 1. 实例化贝塞尔曲线，并且设置基本属性
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineWidth = 1.0f;
    
    // 2. 设置横向显示所有线段
    CGFloat width = self.frame.size.width / allUpLoadArray.count;
    
    // 3. 循环取出数组中的坐标，画线线
    for (int i = 0; i < allUpLoadArray.count; i++) {
        
        CGFloat y = [[allUpLoadArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointMake(i * width, y);
        if (i == 0) {
            [bezierPath moveToPoint:point];
        }else if (i == allUpLoadArray.count - 1){
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

- (NSMutableArray *)upLoadArray
{
    if (!_upLoadArray) {
        _upLoadArray = [NSMutableArray array];
    }
    return _upLoadArray;
}
@end
