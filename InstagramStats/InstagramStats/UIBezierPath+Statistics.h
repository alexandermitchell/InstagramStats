//
//  UIBezierPath+Statistics.h
//  InstagramStats
//
//  Created by atfelix on 2017-06-01.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Statistics)

+(CGPoint)getMidpointBetween:(CGPoint)p and:(CGPoint)q;
+(CGFloat)getHeightForData:(NSNumber *)data withHeight:(CGFloat)height withinMin:(CGFloat)min andMax:(CGFloat)max;
+(CGFloat)getMax:(NSArray<NSNumber *> *)dataset;
+(CGFloat)getMin:(NSArray<NSNumber *> *)dataset;
+(CGPoint)getControlPointFor:(CGPoint)p and:(CGPoint)q;
+(UIBezierPath *)bezierPathForDataset:(NSArray *)dataset withPartitionWidth:(CGFloat)width andHeight:(CGFloat)height;
+(CGFloat)combineX:(NSNumber *)x andY:(NSNumber *)y withLambda:(CGFloat)lambda;

@end
