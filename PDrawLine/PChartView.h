//
//  PChartView.h
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineDataItem;

typedef LineDataItem *(^LineChartDataGetter)(NSUInteger item);

@interface LineDataItem : NSObject

@property (readonly) CGFloat x; // should be within the x range
@property (readonly) CGFloat y; // should be within the y range
@property (readonly) NSString *xLabel; // label to be shown on the x axis
@property (readonly) NSString *dataLabel; // label to be shown directly at the data item

+ (LineDataItem *)dataItemWithX:(CGFloat)x
                              y:(CGFloat)y
                         xLabel:(NSString *)xLabel
                      dataLabel:(NSString *)dataLabel;

@end

@interface LineData : NSObject

@property (nonatomic, retain) UIColor *color;
@property (nonatomic, assign) NSUInteger itemCount;
@property (nonatomic, assign) CGFloat xMin;
@property (nonatomic, assign) CGFloat xMax;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) LineChartDataGetter getData;

@end


//图例说明
@interface LegendView : UIView

@property (nonatomic, retain) UIFont *titlesFont;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSDictionary *colors; // maps titles to UIColors

@end


@interface PChartView : UIView

@property (nonatomic, assign) CGFloat yMin;
@property (nonatomic, assign) CGFloat yMax;

@property (nonatomic, retain) NSArray *xSteps; // Array of step names (NSString). At each step, a scale line is shown. if xSteps's count < 2, nothing is done
@property (nonatomic, retain) NSArray *ySteps; // Array of step names (NSString). At each step, a scale line is shown.
@property (nonatomic, retain) UIFont *scaleFont; // Font in which scale markings are drawn. Defaults to [UIFont systemFontOfSize:10].
@property (nonatomic, assign) BOOL drawsDataPoints; // Switch to turn off circles on data points. On by default.
@property (nonatomic, assign) BOOL drawsDataLines; // Switch to turn off lines connecting data points. On by default.

@property (nonatomic, retain) NSArray *data; // Array of `LineData` objects, one for each line.
@property (nonatomic, retain) UIColor *xTextColor; // Default is [UIColor blackColor].
@property (nonatomic, retain) UIColor *yTextColor; // Default is [UIColor blackColor].
@property (nonatomic, retain) UIColor *gridLineColor; // Default is [UIColor colorWithWhite:0.6 alpha:1.0].
@property (nonatomic, retain) UIColor *indicatorLineColor; // Default is [UIColor colorWithWhite:0.6 alpha:1.0].

@property (nonatomic, assign) NSInteger  sizePoint; //Default is 4
@end
