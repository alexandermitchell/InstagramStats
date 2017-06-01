//
//  CustomCalloutView.h
//  InstagramStats
//
//  Created by Marc Maguire on 2017-06-01.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end
