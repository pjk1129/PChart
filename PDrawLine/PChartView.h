//
//  PChartView.h
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PChartView : UIView

@property (nonatomic, assign) float yMin;
@property (nonatomic, assign) float yMax;

@property (nonatomic, strong) NSArray *xSteps; // Array of step names (NSString). At each step, a scale line is shown. if xSteps's count < 2, nothing is done
@property (nonatomic, strong) NSArray *ySteps; // Array of step names (NSString). At each step, a scale line is shown.
@property (nonatomic, strong) UIFont *scaleFont; // Font in which scale markings are drawn. Defaults to [UIFont systemFontOfSize:10].

@end
