//
//  ChartViewController.m
//  ;
//
//  Created by JK.PENG on 13-10-12.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "ChartViewController.h"
#import "PChartView.h"
#import "NSDate+Expand.h"

@interface ChartViewController ()

@property (nonatomic, retain) UIView   *containerView;
@property (nonatomic, retain) PChartView   *chartView;
@end

@implementation ChartViewController
@synthesize containerView = _containerView;
@synthesize chartView = _chartView;

- (void)dealloc{
    self.chartView = nil;
    self.containerView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Chart";
    
    LineData  *data1 = [[LineData alloc] init];
    NSDate *date11 = [[NSDate date] dateByAddingDays:(-3)];
    NSDate *date12 = [[NSDate date] dateByAddingDays:2];
    data1.xMin = [date11 timeIntervalSinceReferenceDate];
    data1.xMax = [date12 timeIntervalSinceReferenceDate];
    data1.title = @"昨天";
    data1.color = [UIColor grayColor];
    data1.itemCount = 6;
    NSMutableArray *array = [NSMutableArray array];
    for(NSUInteger i = 0; i < 4; ++i) {
        [array addObject:@(data1.xMin + (rand() / (float)RAND_MAX) * (data1.xMax - data1.xMin))];
    }
    [array addObject:@(data1.xMin)];
    [array addObject:@(data1.xMax)];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *array2 = [NSMutableArray array];
    for(NSUInteger i = 0; i < 6; ++i) {
        [array2 addObject:@((rand() / (float)RAND_MAX) * 6)];
    }
    data1.getData = ^(NSUInteger item) {
        float x = [array[item] floatValue];
        float y = [array2[item] floatValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *label1 = [formatter stringFromDate:[date11 dateByAddingTimeInterval:x]];
        NSString *label2 = [NSString stringWithFormat:@"%f", y];
        return [LineDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
    };
    
    
    LineData  *data = [[LineData alloc] init];
    NSDate *date1 = [[NSDate date] dateByAddingDays:(-3)];
    NSDate *date2 = [[NSDate date] dateByAddingDays:2];
    data.xMin = [date1 timeIntervalSinceReferenceDate];
    data.xMax = [date2 timeIntervalSinceReferenceDate];
    data.title = @"今天";
    data.color = [UIColor orangeColor];
    data.itemCount = 8;
    NSMutableArray *arr = [NSMutableArray array];
    for(NSUInteger i = 0; i < data.itemCount - 2; ++i) {
        [arr addObject:@(data.xMin + (rand() / (float)RAND_MAX) * (data.xMax - data.xMin))];
    }
    [arr addObject:@(data.xMin)];
    [arr addObject:@(data.xMax)];
    
    [arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *arr2 = [NSMutableArray array];
    for(NSUInteger i = 0; i < data.itemCount; ++i) {
        [arr2 addObject:@((rand() / (float)RAND_MAX) * 6)];
    }
    data.getData = ^(NSUInteger item) {
        float x = [arr[item] floatValue];
        float y = [arr2[item] floatValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *label1 = [formatter stringFromDate:[date1 dateByAddingTimeInterval:x]];
        NSString *label2 = [NSString stringWithFormat:@"%f", y];
        return [LineDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
    };

    self.chartView.xTextColor = [UIColor redColor];
    self.chartView.yTextColor = [UIColor magentaColor];
    self.chartView.yMin = 0;
    self.chartView.yMax = 6;
    self.chartView.ySteps = @[@"0.0",@"1.0",@"2.0",@"3.0",@"4.0",@"5.0",@"6.0",@"7.0",@"8.0",@"9.0",@"10.0"];
    self.chartView.xSteps = @[@"",@"20:00",@"16:00",@"12:00",@"8:00",@"4:00",@""];
    self.chartView.data = @[data1,data];
    [self.containerView addSubview:self.chartView];
    
}

- (CGRect)getContainerViewFrame:(BOOL)navigationBarHidden
{
    CGFloat  screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat  sizeHeight = navigationBarHidden?screenHeight-20:screenHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat  originY = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)?0:screenHeight-sizeHeight;
    return CGRectMake(0, originY, CGRectGetWidth(self.view.frame), sizeHeight);
}

#pragma - getter
- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:[self getContainerViewFrame:self.navigationController.navigationBarHidden]];
        _containerView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.containerView];
    }
    return _containerView;
}

- (PChartView *)chartView{
    if (!_chartView) {
        _chartView = [[PChartView alloc] initWithFrame:CGRectMake(20, 30, 280, 300)];
    }
    return _chartView;
}

@end
