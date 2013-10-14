//
//  PChartView.m
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "PChartView.h"
#import "NSArray+Expand.h"

#ifdef DEBUG
#define PCVLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define PCVLog(xx, ...)  ((void)0)
#endif

@interface LineDataItem ()

@property (readwrite) CGFloat x; // should be within the x range
@property (readwrite) CGFloat y; // should be within the y range
@property (readwrite) NSString *xLabel; // label to be shown on the x axis
@property (readwrite) NSString *dataLabel; // label to be shown directly at the data item

- (id)initWithhX:(CGFloat)x
               y:(CGFloat)y
          xLabel:(NSString *)xLabel
       dataLabel:(NSString *)dataLabel;

@end

@implementation LineDataItem

- (id)initWithhX:(CGFloat)x
               y:(CGFloat)y
          xLabel:(NSString *)xLabel
       dataLabel:(NSString *)dataLabel {
    self = [super init];
    if(self) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
        self.dataLabel = dataLabel;
    }
    return self;
}

+ (LineDataItem *)dataItemWithX:(CGFloat)x
                              y:(CGFloat)y
                         xLabel:(NSString *)xLabel
                      dataLabel:(NSString *)dataLabel {
    return [[LineDataItem alloc] initWithhX:x y:y xLabel:xLabel dataLabel:dataLabel];
}

@end

@implementation LineData
@synthesize color = _color;
@synthesize itemCount = _itemCount;
@synthesize xMax = _xMax;
@synthesize xMin = _xMin;
@synthesize title = _title;
@synthesize getData = _getData;

@end


static const NSInteger kXAxisSpace = 15;
static const NSInteger kPadding = 10;

@interface PChartView ()

@end

@implementation PChartView
@synthesize yMin = _yMin;
@synthesize yMax = _yMax;
@synthesize xSteps = _xSteps;
@synthesize ySteps = _ySteps;
@synthesize scaleFont = _scaleFont;
@synthesize drawsDataLines = _drawsDataLines;
@synthesize drawsDataPoints = _drawsDataPoints;
@synthesize data = _data;

- (void)dealloc{
    self.xSteps = nil;
    self.ySteps = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizesSubviews = YES;
        self.scaleFont = [UIFont systemFontOfSize:10.0];
        self.drawsDataPoints = YES;
        self.drawsDataLines  = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat availableHeight = self.bounds.size.height - 2 * kPadding - kXAxisSpace;
    
    CGFloat availableWidth = self.bounds.size.width - 2 * kPadding - self.yAxisLabelsWidth;
    CGFloat xStart = kPadding + self.yAxisLabelsWidth;
    CGFloat yStart = kPadding;
    
    static CGFloat dashedPattern[] = {4,2};
    
    // draw scale and horizontal lines
    CGFloat heightPerStep = self.ySteps == nil || [self.ySteps count] == 0 ? availableHeight : (availableHeight / ([self.ySteps count] - 1));
    
    NSUInteger i = 0;
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *step in self.ySteps) {
        [[UIColor grayColor] set];
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        [step drawInRect:CGRectMake(yStart, y - h / 2, self.yAxisLabelsWidth - 6, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
        
        [[UIColor colorWithWhite:0.9 alpha:1.0] set];
        CGContextSetLineDash(context, 0, dashedPattern, 2);
        CGContextMoveToPoint(context, xStart, round(y) + 0.5);
        CGContextAddLineToPoint(context, self.bounds.size.width - kPadding, round(y) + 0.5);
        CGContextStrokePath(context);
        i++;
    }
    
    // draw scale and vertical lines
    NSUInteger xCnt = [self.xSteps count];
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);
        
        [[UIColor grayColor] set];
        for(NSUInteger i = 0; i < xCnt; ++i) {
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            CGFloat h = [self.scaleFont lineHeight];
            CGFloat w = self.yAxisLabelsWidth - 6;
            NSString  *step = [self.xSteps objectAtIndex:i];
            [step drawInRect:CGRectMake(x-w/2, yStart + availableHeight+2, w, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
            
            [[UIColor colorWithWhite:0.9 alpha:1.0] set];
            CGContextMoveToPoint(context, round(x) + 0.5, kPadding);
            CGContextAddLineToPoint(context, round(x) + 0.5, yStart + availableHeight);
            CGContextStrokePath(context);
            
        }
    }
    
    CGContextRestoreGState(context);
    
    if (!self.drawsAnyData) {
        PCVLog(@"You configured LineChartView to draw neither lines nor data points. No data will be visible. This is most likely not what you wanted. (But we aren't judging you, so here's your chart background.)");
    } // warn if no data will be drawn
    
    CGFloat yRangeLen = self.yMax - self.yMin;
    for (LineData *data in self.data) {
        if (self.drawsDataLines) {
            float xRangeLen = data.xMax - data.xMin;
            if(data.itemCount >= 2) {
                LineDataItem *datItem = data.getData(0);
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL,
                                  xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth),
                                  yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight));
                for(NSUInteger i = 1; i < data.itemCount; ++i) {
                    LineDataItem *datItem = data.getData(i);
                    CGPathAddLineToPoint(path, NULL,
                                         xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth),
                                         yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight));
                }
                
                CGContextAddPath(context, path);
                CGContextSetStrokeColorWithColor(context, [self.backgroundColor CGColor]);
                CGContextSetLineWidth(context, 5);
                CGContextStrokePath(context);
                
                CGContextAddPath(context, path);
                CGContextSetStrokeColorWithColor(context, [data.color CGColor]);
                CGContextSetLineWidth(context, 2);
                CGContextStrokePath(context);
                
                CGPathRelease(path);
            }
        } // draw actual chart data
        
        if (self.drawsDataPoints) {
            float xRangeLen = data.xMax - data.xMin;
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                LineDataItem *datItem = data.getData(i);
                CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
                CGFloat yVal = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                [self.backgroundColor setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - 4, yVal - 4, 8, 8));
                [data.color setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - 3, yVal - 3, 6, 6));
                [[UIColor whiteColor] setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - 2, yVal - 2, 4, 4));
            } // for
        } // draw data points
    }
}

#pragma mark - setter
- (void)setData:(NSArray *)data {
    if(data != _data) {
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[data count]];
        NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:[data count]];
        for(LineData *dat in data) {
            [titles addObject:dat.title];
            [colors setObject:dat.color forKey:dat.title];
        }
//        self.legendView.titles = titles;
//        self.legendView.colors = colors;
        
        _data = data;
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

#pragma mark - Helper methods
- (BOOL)drawsAnyData {
    return self.drawsDataPoints || self.drawsDataLines;
}

// TODO: This should really be a cached value. Invalidated if ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    NSNumber *requiredWidth = [[self.ySteps mapWithBlock:^id(id obj) {
        NSString *label = (NSString*)obj;
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        return @(labelSize.width); // Literal NSNumber Conversion
    }] valueForKeyPath:@"@max.self"]; // gets biggest object. Yeah, NSKeyValueCoding. Deal with it.
    return [requiredWidth floatValue] + kPadding;
}

- (CGFloat)xAxisLabelsWidth {
    NSNumber *requiredWidth = [[self.xSteps mapWithBlock:^id(id obj) {
        NSString *label = (NSString*)obj;
        CGSize labelSize = [label sizeWithFont:self.scaleFont];
        return @(labelSize.width); // Literal NSNumber Conversion
    }] valueForKeyPath:@"@max.self"]; // gets biggest object. Yeah, NSKeyValueCoding. Deal with it.
    return [requiredWidth floatValue] + kPadding;
}

@end
