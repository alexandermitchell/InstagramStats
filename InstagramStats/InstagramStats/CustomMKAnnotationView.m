//
//  CustomMKAnnotationView.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-06-01.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "CustomMKAnnotationView.h"

@implementation CustomMKAnnotationView

//need to implement in order to handle touch events when you subclass MKAnnotationView

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

@end
