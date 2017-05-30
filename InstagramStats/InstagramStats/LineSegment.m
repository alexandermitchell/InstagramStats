//
//  LineSegment.m
//  InstagramStats
//
//  Created by atfelix on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "LineSegment.h"

@implementation LineSegment

-(instancetype)initWithStart:(CGPoint) start andEnd:(CGPoint)end andColor:(UIColor *)color {

    self = [super init];
    if (self) {
        _start = start;
        _end = end;
        _lineColor = color;
    }
    return self;
}

- (instancetype)init {
    return [self initWithStart:CGPointMake(0, 0)
                        andEnd:CGPointMake(0, 0)
                      andColor:[UIColor blackColor]];
}


@end
