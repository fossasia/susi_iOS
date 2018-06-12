//
//  TEABarChart.h
//  Xhacker
//
//  Created by Xhacker on 2013-07-25.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface TEABarChart : UIView

// Array of NSNumber
@property (nonatomic) NSArray *data;

// Array of NSString, nil if you don't want labels.
@property (nonatomic) NSArray *xLabels;

// Max y value for chart (only works when autoMax is NO)
@property (nonatomic) IBInspectable CGFloat max;

// Auto set max value
@property (nonatomic) IBInspectable BOOL autoMax;

@property (nonatomic) IBInspectable UIColor *barColor;
@property (nonatomic) NSArray *barColors;
@property (nonatomic) IBInspectable NSInteger barSpacing;
@property (nonatomic) IBInspectable UIColor *backgroundColor;

// Round bar height to pixel for sharper chart
@property (nonatomic) IBInspectable BOOL roundToPixel;

@end
