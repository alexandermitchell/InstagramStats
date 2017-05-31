//
//  PostTableViewCell.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-31.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "PostTableViewCell.h"


@interface PostTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *likesProgress;
@property (weak, nonatomic) IBOutlet UIProgressView *commentsProgress;


@end

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
