//
//  PChartView.h
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LineDataItem : NSObject

@property (assign) CGFloat x; // should be within the x range
@property (assign) CGFloat y; // should be within the y range
@property (copy) NSString *xLabel; // label to be shown on the x axis
@property (copy) NSString *dataValue; // label to be shown directly at the data item

@end

@interface LineData : NSObject

@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, assign) CGFloat xMin;
@property (nonatomic, assign) CGFloat xMax;

@property (nonatomic, copy) NSString *title;

@end


//图例说明
@interface LegendView : UIView

@property (nonatomic, strong) UIFont *titlesFont;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSDictionary *colors; // maps titles to UIColors
@property (nonatomic, strong) UIColor *fillColor; // Default is [UIColor colorWithWhite:0.1 alpha:0.1].

@end


@interface PChartView : UIView

@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat yMax;

@property (nonatomic, strong) NSArray *xSteps; // Array of step names (NSString). At each step, a scale line is shown. if xSteps's count < 2, nothing is done
@property (nonatomic, strong) NSArray *ySteps; // Array of step names (NSString). At each step, a scale line is shown.
@property (nonatomic, strong) UIFont *scaleFont; // Font in which scale markings are drawn. Defaults to [UIFont systemFontOfSize:10].
@property (nonatomic, assign) BOOL drawsDataPoints; // Switch to turn off circles on data points. On by default.
@property (nonatomic, assign) BOOL drawsDataLines; // Switch to turn off lines connecting data points. On by default.

@property (nonatomic, strong) NSArray *data; // Array of `LineData` objects, one for each line.
@property (nonatomic, strong) UIColor *xTextColor; // Default is [UIColor blackColor].
@property (nonatomic, strong) UIColor *yTextColor; // Default is [UIColor blackColor].
@property (nonatomic, strong) UIColor *gridLineColor; // Default is [UIColor colorWithWhite:0.6 alpha:1.0].
@property (nonatomic, strong) UIColor *indicatorLineColor; // Default is [UIColor colorWithWhite:0.6 alpha:1.0].

@property (nonatomic, assign) NSInteger  sizePoint; //Default is 4
@end
