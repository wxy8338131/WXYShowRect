//
//  PictureView.m
//  DrawRectTest
//
//  Created by wangxinyu on 15-1-14.
//  Copyright (c) 2015年 WXY. All rights reserved.
//

#import "WXYShowRectBGView.h"


#define Font 8
#define NumberFont [UIFont systemFontOfSize:Font]
#define leftLineColor [UIColor blueColor]
#define rightLineColor [UIColor purpleColor]

@interface WXYShowRectBGView ()

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@end


@implementation WXYShowRectBGView

- (instancetype)init
{
    if (self == [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        NSLog(@"----");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setModel:(WXYShowModel *)model
{
    _model = model;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // 1. 如果还没有拿到数据模型，那么返回
    if (!self.model) {
        return;
    }
    
    // 1. 开启图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 1.1 设置线条样式
    CGContextSetLineCap(ctx, kCGLineCapButt);
    // 1.2 设置线条粗细宽度
    CGContextSetLineWidth(ctx, 0.5);
    
    // 1.3 设置图文的格子距离
    self.width = rect.size.width;
    self.height = rect.size.height;
    
    // 2. 首先画出一个矩形
    [self drawJuXingKuangWithCtx:ctx CGRect:rect];
    // 3. 绘制横向虚线
    [self drawHengXiangLineWithCtx:ctx CGRect:rect];
    // 4. 绘制纵向虚线
    [self drawZongXiangLineWithCtx:ctx CGRect:rect];
    
}
/**
 *  背景矩形框
 */
- (void)drawJuXingKuangWithCtx:(CGContextRef)ctx CGRect:(CGRect)rect
{
    CGContextAddRect(ctx, rect);
    [[UIColor lightGrayColor] set];
    CGContextStrokePath(ctx);
}
/**
 *  画横向虚线，以及左边右边的数字
 */
- (void)drawHengXiangLineWithCtx:(CGContextRef)ctx CGRect:(CGRect)rect
{
    // 1. 设置length 每画一个点空出一个点
    CGFloat lengths[] = {1,1};
    // 1.2 设置线的粗细
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetLineDash(ctx, 0, lengths, 2);
    
    // 1.3 设置纵距
    int count = 10;
    CGFloat hengMaggin = self.height / count;
    
    // 2. 循环画出横向所有的线
    for (int i = 0; i < count + 1; i++) {
        CGContextMoveToPoint(ctx, 0,(hengMaggin + i * hengMaggin));
        CGContextAddLineToPoint(ctx,self.width,(hengMaggin + i * hengMaggin));
    }
    // 写入表格左边的文字
    for (int i = 0; i < count ; i++) {
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (-hengMaggin / 4 + i * hengMaggin), hengMaggin, hengMaggin)];
        numLabel.text = [NSString stringWithFormat:@"%.0f",self.model.lengthNum - (self.model.lengthNum / 10 * i)];

        numLabel.font = NumberFont;
        numLabel.textColor = leftLineColor;
        [self addSubview:numLabel];
    }
    // 写入表格右边的文字
    for (int i = 0; i < count ; i++) {
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - hengMaggin, (-hengMaggin / 4 + i * hengMaggin), hengMaggin, hengMaggin)];
        numLabel.textAlignment = NSTextAlignmentRight;
        numLabel.text = [NSString stringWithFormat:@"%.0f",self.model.lengthNum - (self.model.lengthNum / 10 * i)];

        numLabel.font = NumberFont;
        numLabel.textColor = rightLineColor;
        [self addSubview:numLabel];
    }

    
    CGContextStrokePath(ctx);
    
}
/**
 *  画纵向虚线
 */
- (void)drawZongXiangLineWithCtx:(CGContextRef)ctx CGRect:(CGRect)rect
{
    // 1. 设置length 每画一个点空出一个点
    CGFloat lengths[] = {1,1};
    // 1.2 设置线的粗细
    CGContextSetLineWidth(ctx, 0.5);
    CGContextSetLineDash(ctx, 0, lengths, 2);
    
    // 1.3 设置纵距
    int count = 15;
    CGFloat zongMaggin = self.width / count;
    
    // 2.1 开始画纵向线
    for (int i = 0; i < count - 1; i++) {
        CGContextMoveToPoint(ctx, (zongMaggin + i * zongMaggin), 0);
        CGContextAddLineToPoint(ctx, (zongMaggin + i * zongMaggin), self.height);
    }
    CGContextStrokePath(ctx);
    
}
@end
