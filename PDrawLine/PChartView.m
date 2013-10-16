//
//  PChartView.m
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "PChartView.h"
#import "NSArray+Expand.h"
#import "UIKit+DrawingHelpers.h"
#import <CoreGraphics/CoreGraphics.h>

#ifdef DEBUG
#define PCVLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define PCVLog(xx, ...)  ((void)0)
#endif

@implementation LineDataItem

@end

@implementation LineData

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end


static const NSInteger kXAxisSpace = 15;
static const NSInteger kPadding = 10;

static const NSInteger kLegendColorPadding = 15;
static const NSInteger kLegendPadding = 5;

@implementation LegendView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fillColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [self.fillColor CGColor]);
    CGContextFillRoundedRect(c, self.bounds, 7);
    
    
    CGFloat y = 0;
    for(NSString *title in self.titles) {
        UIColor *color = [self.colors objectForKey:title];
        if(color) {
            [color setFill];
            CGContextFillEllipseInRect(c, CGRectMake(kLegendPadding + 2, kLegendPadding + round(y) + self.titlesFont.xHeight / 2 + 1, 6, 6));
        }
        [[UIColor whiteColor] set];
        [title drawAtPoint:CGPointMake(kLegendColorPadding + kLegendPadding, y + kLegendPadding + 1) withFont:self.titlesFont];
        [[UIColor blackColor] set];
        [title drawAtPoint:CGPointMake(kLegendColorPadding + kLegendPadding, y + kLegendPadding) withFont:self.titlesFont];
        y += [self.titlesFont lineHeight];
    }
}

- (UIFont *)titlesFont {
    if(_titlesFont == nil)
        _titlesFont = [UIFont boldSystemFontOfSize:10];
    return _titlesFont;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat h = [self.titlesFont lineHeight] * [self.titles count];
    CGFloat w = 0;
    for(NSString *title in self.titles) {
        CGSize s = [title sizeWithFont:self.titlesFont];
        w = MAX(w, s.width);
    }
    return CGSizeMake(kLegendColorPadding + w + 2 * kLegendPadding, h + 2 * kLegendPadding);
}

@end

@interface PChartView ()

@property (nonatomic, retain) LegendView   *legendView;
@property (nonatomic, retain) UIView       *currentIndicatorLine;
@property (nonatomic, retain) UILabel      *infoLabel;

@end

@implementation PChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        self.autoresizesSubviews = YES;
        self.scaleFont = [UIFont systemFontOfSize:10.0];
        self.drawsDataPoints = YES;
        self.drawsDataLines  = YES;
        self.xTextColor = [UIColor blackColor];
        self.yTextColor = [UIColor blackColor];
        self.gridLineColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.sizePoint = 4;
        self.currentIndicatorLine.backgroundColor = [UIColor redColor];
        [self addSubview:self.legendView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.legendView.frame;
    r.origin.x = self.frame.size.width - self.legendView.frame.size.width - 3 - kPadding;
    r.origin.y = 3 + kPadding;
    self.legendView.frame = r;
    
    CGRect f = self.currentIndicatorLine.frame;
    CGFloat h = self.frame.size.height;
    f.size.height = h - 4 * kPadding - kXAxisSpace;
    self.currentIndicatorLine.frame = f;

    [self bringSubviewToFront:self.legendView];

}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat availableHeight = self.bounds.size.height - 4 * kPadding - kXAxisSpace;
    
    CGFloat availableWidth = self.bounds.size.width - kPadding - self.yAxisLabelsWidth;
    CGFloat xStart = self.yAxisLabelsWidth;
    CGFloat yStart = 3*kPadding;
    
    static CGFloat dashedPattern[] = {4,2};
    
    
    CGFloat heightPerStep = (self.ySteps == nil || [self.ySteps count] == 0) ? availableHeight : (availableHeight / ([self.ySteps count] - 1));
    
    NSUInteger i = 0;
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0, dashedPattern, 2);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *step in self.ySteps) {
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        [self.yTextColor set];
        [step drawInRect:CGRectMake(xStart-self.yAxisLabelsWidth + 4, y - h / 2, self.yAxisLabelsWidth - 6, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
        
        [self.gridLineColor set];
        CGContextMoveToPoint(context, xStart, round(y) + 0.5);
        CGContextAddLineToPoint(context, self.bounds.size.width - kPadding, round(y) + 0.5);
        CGContextStrokePath(context);
        i++;
    }// draw scale and horizontal lines
    
    
    NSUInteger xCnt = [self.xSteps count];
    if(xCnt > 1) {
        CGFloat widthPerStep = availableWidth / (xCnt - 1);
        for(NSUInteger i = 0; i < xCnt; ++i) {
            CGFloat x = xStart + widthPerStep * (xCnt - 1 - i);
            CGFloat h = [self.scaleFont lineHeight];
            CGFloat w = self.yAxisLabelsWidth - 4;
            NSString  *step = [self.xSteps objectAtIndex:i];
            [self.xTextColor set];
            [step drawInRect:CGRectMake(x-w/2, yStart + availableHeight+2, w, h) withFont:self.scaleFont lineBreakMode:NSLineBreakByClipping alignment:NSTextAlignmentRight];
            
            [self.gridLineColor set];
            CGContextMoveToPoint(context, round(x) + 0.5, yStart);
            CGContextAddLineToPoint(context, round(x) + 0.5, yStart + availableHeight);
            CGContextStrokePath(context);
            
        }
    }// draw scale and vertical lines
    
    CGContextRestoreGState(context);
    
    if (!self.drawsAnyData) {
        PCVLog(@"You configured LineChartView to draw neither lines nor data points. No data will be visible. This is most likely not what you wanted. (But we aren't judging you, so here's your chart background.)");
    } // warn if no data will be drawn
    
    CGFloat yRangeLen = self.yMax - self.yMin;
    for (LineData *data in self.data) {
        if (self.drawsDataLines) {
            float xRangeLen = data.xMax - data.xMin;
            if(data.itemCount >= 2) {
                LineDataItem *datItem = [data.dataArray objectAtIndex:0];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL,
                                  xStart + round(((datItem.x - data.xMin) / xRangeLen) * availableWidth),
                                  yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight));
                for(NSUInteger i = 1; i < data.itemCount; ++i) {
                    LineDataItem *item = [data.dataArray objectAtIndex:i];
                    CGPathAddLineToPoint(path, NULL,
                                         xStart + round(((item.x - data.xMin) / xRangeLen) * availableWidth),
                                         yStart + round((1.0 - (item.y - self.yMin) / yRangeLen) * availableHeight));
                }
                
                CGContextAddPath(context, path);
                CGContextSetStrokeColorWithColor(context, [data.color CGColor]);
                CGContextSetLineWidth(context, 1.5);
                CGContextStrokePath(context);
                
                CGPathRelease(path);
            }
        } // draw actual chart data
        
        if (self.drawsDataPoints) {
            float xRangeLen = data.xMax - data.xMin;
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                LineDataItem *datItem = [data.dataArray objectAtIndex:i];
                CGFloat xVal = xStart + round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
                CGFloat yVal = yStart + round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
                [data.color setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - self.sizePoint/2, yVal - self.sizePoint/2, self.sizePoint, self.sizePoint));
                [[UIColor whiteColor] setFill];
                CGContextFillEllipseInRect(context, CGRectMake(xVal - self.sizePoint/4, yVal - self.sizePoint/4, self.sizePoint/2, self.sizePoint/2));
            } // for
        } // draw data points
        
        
        //default display current data value
        NSInteger  index = [self.data indexOfObjectIdenticalTo:data];
        if (index == 0) {
            LineDataItem *datItem = [data.dataArray objectAtIndex:index];
            if (datItem.dataValue) {
                self.infoLabel.text = [NSString stringWithFormat:@"当前值: %@",datItem.dataValue];
                [self.infoLabel sizeToFit];
                
                CGRect f = self.infoLabel.frame;
                f.origin.x = self.yAxisLabelsWidth;
                f.origin.y = 3*kPadding-self.infoLabel.frame.size.height-2;
                self.infoLabel.frame = f;
            }
        }
        
    }
    
    
}


#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorByCurrentTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorByCurrentTouch:[touches anyObject]];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}

- (void)showIndicatorByCurrentTouch:(UITouch *)touch
{
    
    CGPoint pos = [touch locationInView:self];
    CGFloat xStart = self.yAxisLabelsWidth;
    CGFloat yStart = 3*kPadding;
    CGFloat yRangeLen = self.yMax - self.yMin;
    CGFloat xPos = pos.x - xStart;
    CGFloat yPos = pos.y - yStart;
    CGFloat availableWidth = self.bounds.size.width - kPadding - self.yAxisLabelsWidth;
    CGFloat availableHeight = self.bounds.size.height - 4 * kPadding - kXAxisSpace;
    
    LineDataItem *closest = nil;
    float minDist = FLT_MAX;
    float minDistY = FLT_MAX;
    CGPoint closestPos = CGPointZero;
    
    for(LineData *data in self.data) {
        float xRangeLen = data.xMax - data.xMin;
        for(NSUInteger i = 0; i < data.itemCount; ++i) {
            LineDataItem *datItem = [data.dataArray objectAtIndex:i];
            CGFloat xVal = round((xRangeLen == 0 ? 0.5 : ((datItem.x - data.xMin) / xRangeLen)) * availableWidth);
            CGFloat yVal = round((1.0 - (datItem.y - self.yMin) / yRangeLen) * availableHeight);
            
            float dist = fabsf(xVal - xPos);
            float distY = fabsf(yVal - yPos);
            if(dist < minDist || (dist == minDist && distY < minDistY)) {
                minDist = dist;
                minDistY = distY;
                closest = datItem;
                closestPos = CGPointMake(xStart + xVal - 3, yStart + yVal - 7);
            }
        }
    }
    
    if (closest.dataValue) {
        self.infoLabel.text = [NSString stringWithFormat:@"当前值: %@",closest.dataValue];
        [self.infoLabel sizeToFit];
        
        CGRect f = self.infoLabel.frame;
        f.origin.x = self.yAxisLabelsWidth;
        f.origin.y = 3*kPadding-self.infoLabel.frame.size.height-2;
        self.infoLabel.frame = f;
    }
    
    if(self.currentIndicatorLine.alpha == 0.0) {
        CGRect r = self.currentIndicatorLine.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentIndicatorLine.frame = r;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.currentIndicatorLine.alpha = 1.0;

        CGRect r = self.currentIndicatorLine.frame;
        r.origin.x = closestPos.x + 3 - 1;
        self.currentIndicatorLine.frame = r;
    }];

}

- (void)hideIndicator {
    [UIView animateWithDuration:0.1 animations:^{
        self.currentIndicatorLine.alpha = 0.0;
    }];
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
        self.legendView.titles = titles;
        self.legendView.colors = colors;
        
        _data = data;
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

#pragma mark - getter
- (LegendView *)legendView{
    if (!_legendView) {
        _legendView = [[LegendView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 50 - 10, 10, 50, 30)];
        _legendView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _legendView.backgroundColor = [UIColor clearColor];
    }
    return _legendView;
}

- (UIView *)currentIndicatorLine{
    if (!_currentIndicatorLine) {
        _currentIndicatorLine = [[UIView alloc] initWithFrame:CGRectMake(kPadding, 3*kPadding, 2 / self.contentScaleFactor, 50)];
        _currentIndicatorLine.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _currentIndicatorLine.alpha = 0.0;
        [self addSubview:_currentIndicatorLine];
    }
    return _currentIndicatorLine;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = [UIColor grayColor];
        _infoLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
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
