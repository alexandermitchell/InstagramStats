//
//  UIBezierPath+Statistics.m
//  InstagramStats
//
//  Created by atfelix on 2017-06-01.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "UIBezierPath+Statistics.h"

@implementation UIBezierPath (Statistics)

+(CGFloat)getHeightForData:(NSNumber *)data withHeight:(CGFloat)height withinMin:(CGFloat)min andMax:(CGFloat)max {

    if (max == min) {
        return 0;
    }

    CGFloat c = ([data doubleValue] - min) / (max - min);
    return height * (1 - c);
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
    CGPoint controlPoint = [self getMidpointBetween:p and:q];
    CGFloat diffY = fabs(q.y - controlPoint.y);

    controlPoint.y += (p.y < q.y) ? +diffY : -diffY;

    return controlPoint;
}

+(UIBezierPath *)bezierPathForDataset:(NSArray *)dataset withPartitionWidth:(CGFloat)width andHeight:(CGFloat)height {
    UIBezierPath *path = [[UIBezierPath alloc] init];

    CGFloat maxData = [self getMax:dataset];
    CGFloat minData = [self getMin:dataset];

    [path moveToPoint:CGPointMake(0, [self getHeightForData:dataset[0]
                                                 withHeight:height
                                                  withinMin:minData
                                                     andMax:maxData])];

    for (int i = 1; i < dataset.count; i++) {
        CGPoint p = CGPointMake((i - 1) * width, [self getHeightForData:dataset[i - 1]
                                                             withHeight:height
                                                              withinMin:minData
                                                                 andMax:maxData]);

        CGPoint q = CGPointMake(i * width, [self getHeightForData:dataset[i]
                                                                withHeight:height
                                                                 withinMin:minData
                                                                    andMax:maxData]);

        CGPoint midpoint = [self getMidpointBetween:p and:q];
        CGPoint controlPoint1 = [self getControlPointFor:midpoint and:p];
        CGPoint controlPoint2 = [self getControlPointFor:midpoint and:q];

        [path addQuadCurveToPoint:midpoint controlPoint:controlPoint1];
        [path addQuadCurveToPoint:q controlPoint:controlPoint2];
    }
    
    return path;
}

+(CGFloat)combineX:(NSNumber *)x andY:(NSNumber *)y withLambda:(CGFloat)lambda {
    return [x doubleValue] * (1 - lambda) + [y doubleValue] * lambda;
}

@end
