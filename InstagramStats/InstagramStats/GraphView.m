//
//  GraphView.m
//  InstagramStats
//
//  Created by atfelix on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "GraphView.h"

@import UIKit;
@import CoreGraphics;

#import "LineSegment.h"

@interface GraphView ()

@property (nonatomic, copy) NSMutableArray<LineSegment *> *likesLineSegments;
@property (nonatomic, copy) NSMutableArray<LineSegment *> *commentsLineSegments;

@end

@implementation GraphView


- (void)drawRect:(CGRect)rect {
    self.layer.backgroundColor = [UIColor blackColor].CGColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat verticalLineWidth = self.frame.size.width / self.likesLineSegments.count;

    for (int i = 0; i < self.likesLineSegments.count; i++) {
        [self drawVerticalLineAt:i * verticalLineWidth
                          withContext:context];
    }
}


-(void) drawVerticalLineAt:(CGFloat)locationX withContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, locationX, 0);
    CGContextAddLineToPoint(context, locationX, self.frame.size.height);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
}


@end
