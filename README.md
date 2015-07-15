# WXYShowRect
快速创建渐变图表，可以展示历史数据，可以时时根据传入值绘画出图表。

# 1.要引入两个头文件
 #import "WXYShowRectView.h"
 
 #import "WXYShowModel.h"
 
# 2. 首先需要实例化WXYShowRectView和WXYShowModel
    // 1. 实例化视图对象
    WXYShowRectView *showView = [[WXYShowRectView alloc] init];
    
    // 2. 配置参数模型
    WXYShowModel *model = [[WXYShowModel alloc] init];
    /*设置上行线段已经背景渐变图层颜色*/
    model.upLoadColor = [UIColor blueColor];
    /*设置下行线段已经背景渐变图层颜色*/
    model.downLoadColor = [UIColor greenColor];
    /*设置屏幕横向需要绘制多少条线段*/
    model.widthNum = 100;
    /*设置屏幕纵向需要绘制多少条线段*/
    model.lengthNum = 100;
    /*设置图表的Frame*/
    model.frame = CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
# 3. 展示视图
    [showView showRectWithModel:model];
    
    /*获得两个随机值*/
    int number = arc4random() % 20 + 60;
    int number2 = arc4random() % 30 + 10;
    /*传入上行值和下行值，每传入一次，如表刷新变化一次，间隔时间又传入数据时间并行*/
    self.showView.httpDownLoad = number;
    self.showView.httpUpLoad = number2;
    
# 4. 展示历史数据图表
/**
 *  上下行速率同时显示在一张表上
 *
 *  @param allDownLoadArray 下行总数组
 *  @param allUpLoadArray   上行总数组
 */
- (void)showAllSpeedWithDownLoadArray:(NSArray *)DownArray upLoadArray:(NSArray *)UpArray;
使用方法：
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

