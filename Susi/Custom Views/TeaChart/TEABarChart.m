//
//  TEABarChart.m
//  Xhacker
//
//  Created by Xhacker on 2013-07-25.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "TEABarChart.h"

@interface TEABarChart ()

/**
 @discussion    A mutable array of elements that will be made available to VoiceOver.
 */
@property (nonatomic, strong) NSMutableArray *accessibleElements;

@end

@implementation TEABarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self loadDefaults];
    }
    return self;
}

- (void)loadDefaults
{
    self.opaque = NO;
    
    // Initialize an empty array which will be populated in -drawRect:
    self.accessibleElements = [[NSMutableArray alloc] init];

    _xLabels = nil;

    _autoMax = YES;

    _barColor = [UIColor colorWithRed:106.0/255 green:175.0/255 blue:232.0/255 alpha:1];
    _barSpacing = 8;
    _backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    _roundToPixel = YES;
}

- (void)prepareForInterfaceBuilder
{
    [self loadDefaults];
    
    self.data = @[@3, @1, @4, @1, @5, @9, @2, @6];
    self.xLabels = @[@"T", @"E", @"A", @"C", @"h", @"a", @"r", @"t"];
}

- (void)drawRect:(CGRect)rect
{    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    double max = self.autoMax ? [[self.data valueForKeyPath:@"@max.self"] doubleValue] : self.max;
    CGFloat barMaxHeight = CGRectGetHeight(rect);
    NSInteger numberOfBars = self.data.count;
    CGFloat barWidth = (CGRectGetWidth(rect) - self.barSpacing * (numberOfBars - 1)) / numberOfBars;
    CGFloat barWidthRounded = ceil(barWidth);

    if (self.xLabels) {
        CGFloat fontSize = floor(barWidth);
        CGFloat labelsTopMargin = ceil(fontSize * 0.33);
        barMaxHeight -= (fontSize + labelsTopMargin);

        [self.xLabels enumerateObjectsUsingBlock:^(NSString *label, NSUInteger idx, BOOL *stop) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
            paragraphStyle.alignment = NSTextAlignmentCenter;

            [label drawInRect:CGRectMake(idx * (barWidth + self.barSpacing), barMaxHeight + labelsTopMargin, barWidth, fontSize * 1.2)
               withAttributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize],
                                NSForegroundColorAttributeName:[UIColor colorWithWhite:0.56 alpha:1],
                                NSParagraphStyleAttributeName:paragraphStyle,
                                }];
        }];
    }

    for (NSInteger i = 0; i < numberOfBars; i += 1)
    {
        CGFloat barHeight = (max == 0 ? 0 : barMaxHeight * [self.data[i] floatValue] / max);
        if (barHeight > barMaxHeight) {
            barHeight = barMaxHeight;
        }
        if (self.roundToPixel) {
            barHeight = (int)barHeight;
        }
        
        CGFloat x = floor(i * (barWidth + self.barSpacing));
      
        [self.backgroundColor setFill];
        CGRect backgroundRect = CGRectMake(x, 0, barWidthRounded, barMaxHeight);
        CGContextFillRect(context, backgroundRect);
      
        UIColor *barColor = self.barColors ? self.barColors[i % self.barColors.count] : self.barColor;
        [barColor setFill];
        CGRect barRect = CGRectMake(x, barMaxHeight - barHeight, barWidthRounded, barHeight);
        CGContextFillRect(context, barRect);
        
        // Populate self.accessibleElements with each bar's name and value.
        UIAccessibilityElement *element = [[UIAccessibilityElement alloc] initWithAccessibilityContainer:self];
        // The frame can be set to just rect, if it improves usability.
        element.accessibilityFrame = [self convertRect:barRect toView:nil];
        // If xLabels has not been initialized, give each bar a name to identify them in the accessibiltyLabel.
        NSString *barLabel = self.xLabels[i] ? self.xLabels[i] : [NSString stringWithFormat: @"Bar %ld of %ld", i + 1, numberOfBars];
        
        // Combine eacb bar's title and value into the accessiblityLabel.
        /* The label uses a percentage estimate, in case the value and max are too large, but if a use case
         * requires count out of a total, substitute the following single-line comment.
         */
        // [NSString stringWithFormat:@"%@ : %@ out of %d", barLabel, self.data[i], (int)max];
        double percentage = [(NSNumber *)(self.data[i]) doubleValue]/max;
        element.accessibilityLabel = [NSString stringWithFormat:@"%@ : %.2f %%", barLabel, percentage * 100.0];
        [self.accessibleElements addObject:element];
    }
}

#pragma mark Accessibility

- (BOOL)isAccessibilityElement
{
    return NO;
}

- (NSInteger)accessibilityElementCount
{
    return self.data.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index
{
    return self.accessibleElements[index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element
{
    return [self.accessibleElements indexOfObject:element];
}

#pragma mark Setters

- (void)setData:(NSArray *)data
{
    _data = data;
    [self setNeedsDisplay];
}

- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    [self setNeedsDisplay];
}

- (void)setMax:(CGFloat)max
{
    _max = max;
    [self setNeedsDisplay];
}

- (void)setAutoMax:(BOOL)autoMax
{
    _autoMax = autoMax;
    [self setNeedsDisplay];
}

- (void)setBarColors:(NSArray *)barColors
{
    _barColors = barColors;
    [self setNeedsDisplay];
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    [self setNeedsDisplay];
}

- (void)setBarSpacing:(NSInteger)barSpacing
{
    _barSpacing = barSpacing;
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

@end
