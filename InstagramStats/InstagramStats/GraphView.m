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

@property (nonatomic, copy) NSMutableArray<LineSegment *> *likesDataSet;
@property (nonatomic, copy) NSMutableArray<LineSegment *> *commentsDataSet;

@end

@implementation GraphView


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self setupBackgroundGrid:context];
    [self drawLikesLineWithContext:context];
    [self drawCommentsLineWithContext:context];
}


#pragma mark - Utility Functions


-(void) drawVerticalLineAt:(CGFloat)locationX withContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, locationX, 0);
    CGContextAddLineToPoint(context, locationX, self.frame.size.height);
    CGContextSetLineWidth(context, 2.0);
    CGContextStrokePath(context);
}

-(void)setupBackgroundGrid:(CGContextRef)context {

    self.layer.backgroundColor = [UIColor blackColor].CGColor;

    CGFloat verticalLineWidth = self.frame.size.width / self.likesDataSet.count;
    for (int i = 0; i < self.likesDataSet.count; i++) {
        [self drawVerticalLineAt:i * verticalLineWidth
                     withContext:context];
    }
}

-(void)drawLikesLineWithContext:(CGContextRef)context {
    [GraphView drawLineWithData:self.likesDataSet andContext:context andColor:[UIColor blueColor]];
}

-(void)drawCommentsLineWithContext:(CGContextRef)context {
    [GraphView drawLineWithData:self.commentsDataSet andContext:context andColor:[UIColor redColor]];
}

+(void)drawLineWithData:(NSArray<LineSegment *> *)lineSegments andContext:(CGContextRef)context andColor:(UIColor *)color {

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [color setStroke];

    for (LineSegment *segment in lineSegments) {
        [path moveToPoint:segment.start];
        [path addLineToPoint:segment.end];
    }
    [path stroke];

}


@end
