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


@interface GraphView ()

@property (nonatomic) CGFloat partitionWidth;

@end

@implementation GraphView


-(instancetype)init {

    self = [super init];
    if (self) {
        self.likesDataSet = [[NSMutableArray alloc] init];
        self.commentsDataSet = [[NSMutableArray alloc] init];

        for (int i = 0; i < 20; i++) {
            [self.likesDataSet addObject:@(arc4random_uniform(30) + 10)];
            [self.commentsDataSet addObject:@(arc4random_uniform(20))];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.partitionWidth = self.frame.size.width / self.likesDataSet.count;
    [self setupBackgroundGrid:context];
    [self drawLikesLineWithContext:context];
    [self drawCommentsLineWithContext:context];
}


#pragma mark - Utility Functions


-(void)setupBackgroundGrid:(CGContextRef)context {

    self.layer.backgroundColor = [UIColor blackColor].CGColor;

    for (int i = 0; i < self.likesDataSet.count; i++) {
        [self drawVerticalLineAt:i * self.partitionWidth
                     withContext:context];
    }
}

-(void) drawVerticalLineAt:(CGFloat)locationX withContext:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextMoveToPoint(context, locationX, 0);
    CGContextAddLineToPoint(context, locationX, self.frame.size.height);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetAlpha(context, 0.5);
    CGContextStrokePath(context);
    CGContextSetAlpha(context, 1.0);
}

-(void)drawLikesLineWithContext:(CGContextRef)context {
    [self drawLineWithData:self.likesDataSet andContext:context andColor:[UIColor blueColor]];
}

-(void)drawCommentsLineWithContext:(CGContextRef)context {
    [self drawLineWithData:self.commentsDataSet andContext:context andColor:[UIColor redColor]];
}

-(void)drawLineWithData:(NSArray<NSNumber *> *)dataset andContext:(CGContextRef)context andColor:(UIColor *)color {

    if (dataset.count < 2) {
        return;
    }

    UIBezierPath *path = [[UIBezierPath alloc] init];
    [color setStroke];
    path.lineWidth = 3.0;

    if (dataset.count == 2) {
        CGFloat maxData = [GraphView getMax:dataset];
        CGFloat minData = [GraphView getMin:dataset];

        [path moveToPoint:CGPointMake(0, [self getHeightForData:dataset[0]
                                                      WithinMin:minData
                                                         andMax:maxData])];
        [path addLineToPoint:CGPointMake(self.frame.size.width, [self getHeightForData:dataset[1]
                                                                             WithinMin:minData
                                                                                andMax:maxData])];
    }
    else {
        [self drawQuadCurveForData:dataset onPath:path];
    }
    [path stroke];

}

+(CGFloat)getMax:(NSArray<NSNumber *> *)dataset {
    NSNumber *max = dataset[0];

    for (int i = 0; i < dataset.count; i++) {
        if ([max compare:dataset[i]] == NSOrderedAscending) {
            max = dataset[i];
        }
    }
    return [max doubleValue];
}

+(CGFloat)getMin:(NSArray<NSNumber *> *)dataset {
    NSNumber *min = dataset[0];

    for (int i = 0; i < dataset.count; i++) {
        if ([min compare:dataset[i]] == NSOrderedDescending) {
            min = dataset[i];
        }
    }
    return [min doubleValue];
}

+(CGPoint)getMidpointBetween:(CGPoint)p and:(CGPoint)q {
    return CGPointMake((p.x + q.x) / 2, (p.y + q.y) / 2);
}

+(CGPoint)getControlPointFor:(CGPoint)p and:(CGPoint)q {
    CGPoint controlPoint = [GraphView getMidpointBetween:p and:q];
    CGFloat diffY = fabs(q.y - controlPoint.y);

    controlPoint.y += (p.y < q.y) ? +diffY : -diffY;

    return controlPoint;
}

-(CGFloat)getHeightForData:(NSNumber *)data WithinMin:(CGFloat)min andMax:(CGFloat)max {
    if (max == min) {
        return 0;
    }

    CGFloat c = ([data doubleValue] - min) / (max - min);
    return self.frame.size.height * (1 - c);
}

-(void)drawQuadCurveForData:(NSArray<NSNumber *> *)dataset onPath:(UIBezierPath *)path {
    CGFloat maxData = [GraphView getMax:dataset];
    CGFloat minData = [GraphView getMin:dataset];

    [path moveToPoint:CGPointMake(0, [self getHeightForData:dataset[0]
                                                  WithinMin:minData
                                                     andMax:maxData])];

    for (int i = 1; i < dataset.count; i++) {
        CGPoint p = CGPointMake((i - 1) * self.partitionWidth, [self getHeightForData:dataset[i - 1]
                                                                      WithinMin:minData
                                                                         andMax:maxData]);
        CGPoint q = CGPointMake(i * self.partitionWidth, [self getHeightForData:dataset[i]
                                                                      WithinMin:minData
                                                                         andMax:maxData]);

        CGPoint midpoint = [GraphView getMidpointBetween:p and:q];
        CGPoint controlPoint1 = [GraphView getControlPointFor:midpoint and:p];
        CGPoint controlPoint2 = [GraphView getControlPointFor:midpoint and:q];

        [path addQuadCurveToPoint:midpoint controlPoint:controlPoint1];
        [path addQuadCurveToPoint:q controlPoint:controlPoint2];
    }
}


@end
