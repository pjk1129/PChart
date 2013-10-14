//
//  PChartView.m
//  PChart
//
//  Created by JK.Peng on 13-10-14.
//  Copyright (c) 2013年 NJUT. All rights reserved.
//

#import "PChartView.h"
#import "NSArray+Expand.h"

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
}

#pragma mark - Helper methods
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
