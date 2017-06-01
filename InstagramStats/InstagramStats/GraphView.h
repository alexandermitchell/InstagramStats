//
//  GraphView.h
//  InstagramStats
//
//  Created by atfelix on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView

@property (nonatomic) NSMutableArray<NSNumber *> *likesDataSet;
@property (nonatomic) NSMutableArray<NSNumber *> *commentsDataSet;

+(CGFloat)getMin:(NSArray<NSNumber *> *)dataset;
+(CGFloat)getMax:(NSArray<NSNumber *> *)dataset;

@end
