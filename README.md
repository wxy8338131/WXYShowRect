# WXYShowRect
快速创建渐变图表，可以展示历史数据，可以时时根据传入值绘画出图表/Quickly create gradient chart, you can display historical data, you can always according to the incoming value of drawing a chart.

![介绍图片](http://a3.qpic.cn/psb?/V10BO16N3Kz2Tp/Jj1g5tQLphhjjRx6JFp4QB3cRz1VjaL*NfonRiho4cE!/b/dCwAAAAAAAAA&bo=dQGtAgAAAAACNco!&rf=viewer_4)

# 1.首先需要要引入两个头文件/First need to introduce two header file
 #import "WXYShowRectView.h"
 
 #import "WXYShowModel.h"
 
# 2. 随后需要实例化WXYShowRectView和WXYShowModel/Then you need to be "WXYShowRectView" and "WXYShowModel"
    // 1. 实例化视图对象/Instance view object
    WXYShowRectView *showView = [[WXYShowRectView alloc] init];
    
    // 2. 配置参数模型/Configuration parameter model
    WXYShowModel *model = [[WXYShowModel alloc] init];
    //设置上行线段已经背景渐变图层颜色/Set up the background gradient layer color
    model.upLoadColor = [UIColor blueColor];
    //设置下行线段已经背景渐变图层颜色/Set down the line segment has been background gradient layer
    model.downLoadColor = [UIColor greenColor];
    //设置屏幕横向需要绘制多少条线段/How many line segments are required to set up the screen
    model.widthNum = 100;
    //设置屏幕纵向需要绘制多少条线段/How many line segments are set up for the screen
    model.lengthNum = 100;
    //设置图表的Frame/Set the chart's Frame
    model.frame = CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
# 3. 展示视图/Display view
    [showView showRectWithModel:model];
    
    //获得两个随机值/Get two random values
    int number = arc4random() % 20 + 60;
    int number2 = arc4random() % 30 + 10;
    /*传入上行值和下行值，每传入一次，如表刷新变化一次，间隔时间又传入数据时间并行*/Ascending and descending values are passed to one time, such as the change of the table refresh, and the time interval between the time and the incoming data.
    self.showView.httpDownLoad = number;
    self.showView.httpUpLoad = number2;
    
# 4. 展示历史数据图表/Display historical data chart

    //- (void)showAllSpeedWithDownLoadArray:(NSArray *)DownArray upLoadArray:(NSArray *)UpArray;

    // 1. 实例化视图对象/Instance view object
    WXYShowRectView *showView = [[WXYShowRectView alloc] init];
    
    // 2. 配置参数模型/Configuration parameter model
    WXYShowModel *model = [[WXYShowModel alloc] init];
    model.upLoadColor = [UIColor blueColor];
    model.downLoadColor = [UIColor greenColor];
    model.widthNum = 150;
    model.lengthNum = 100;
    model.frame = CGRectMake(10, 350, [UIScreen mainScreen].bounds.size.width - 20, 200);
    
    // 3. 展示视图/Display view
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
    // 4. 调用方法配置数组参数、下行总数组/Downlink total array、上行总数组/Uplink total array
    [showView showAllSpeedWithDownLoadArray:array upLoadArray:array1];
