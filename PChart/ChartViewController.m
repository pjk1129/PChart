//
//  ChartViewController.m
//  ;
//
//  Created by JK.PENG on 13-10-12.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "ChartViewController.h"
#import "PChartView.h"

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
    
    LineData  *data = [[LineData alloc] init];
    data.xMin = 1;
    data.xMax = 24;
    data.title = @"The title for the legend";
    data.color = [UIColor redColor];
    data.itemCount = 10;
    
    NSMutableArray *vals = [NSMutableArray new];
    for(NSUInteger i = 0; i < data.itemCount; ++i)
        [vals addObject:@((rand() / (float)RAND_MAX) * (31 - 1) + 1)];
    [vals sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    data.getData = ^(NSUInteger item) {
        float x = [vals[item] floatValue];
        float y = powf(2, x / 7);
        NSString *label1 = [NSString stringWithFormat:@"%lu", (unsigned long)item];
        NSString *label2 = [NSString stringWithFormat:@"%f", y];
        return [LineDataItem dataItemWithX:x y:y xLabel:label1 dataLabel:label2];
    };
    
    self.chartView.yMin = 0;
    self.chartView.yMax = 6;
    self.chartView.ySteps = @[@"0.0",@"1.0",@"2.0",@"3.0",@"4.0",@"5.0",@"6.0",@"7.0",@"8.0",@"9.0",@"10.0"];
    self.chartView.xSteps = @[@"",@"20.00",@"16.00",@"12.00",@"8.00",@"4.00",@""];
    self.chartView.data = @[data];
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
