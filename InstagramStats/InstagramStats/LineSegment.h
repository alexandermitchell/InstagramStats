//
//  LineSegment.h
//  InstagramStats
//
//  Created by atfelix on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

@import UIKit;

@interface LineSegment : NSObject

@property (nonatomic, assign) CGPoint start;
@property (nonatomic, assign) CGPoint end;

-(instancetype)initWithStart:(CGPoint) start andEnd:(CGPoint)end;

@end
