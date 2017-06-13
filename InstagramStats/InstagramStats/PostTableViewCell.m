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
@property (weak, nonatomic) IBOutlet UILabel *totalLikes;
@property (weak, nonatomic) IBOutlet UILabel *totalComments;

@property (weak, nonatomic) IBOutlet UIProgressView *likesProgress;
@property (weak, nonatomic) IBOutlet UILabel *minLike;
@property (weak, nonatomic) IBOutlet UILabel *maxLike;

@property (weak, nonatomic) IBOutlet UIProgressView *commentsProgress;
@property (weak, nonatomic) IBOutlet UILabel *minComment;
@property (weak, nonatomic) IBOutlet UILabel *maxComment;



@end

@implementation PostTableViewCell

-(void)setDisplayPhoto:(Photo *)displayPhoto {
    
    
    _displayPhoto = displayPhoto;
}

- (void)setMinMaxValues {
    //get and set minlike
    self.minLike.text = [self getMinLikes:self.photos];
    
    //get and set maxLike
    self.maxLike.text = [self getMaxLikes:self.photos];
    
    //get and set minComment
    self.minComment.text = [self getMinComments:self.photos];
    
    //get and set maxComment
    self.maxComment.text = [self getMaxComments:self.photos];
    
}

- (void)updateCellValues {
    
    
    //set postImageView
    self.postImageView.image = [UIImage imageWithData:self.displayPhoto.image];
    
    //set totalLikes
    self.totalLikes.text = [NSString stringWithFormat:@"%hd",self.displayPhoto.likesNum];
    //set totalComments
    
    self.totalComments.text = [NSString stringWithFormat:@"%hd",self.displayPhoto.commentsNum];
    
    
    //set likeprogressbar (totalcomments / max comments)
    self.likesProgress.progress = ((float)self.displayPhoto.likesNum / [self.maxLike.text floatValue]);
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.likesProgress.progress = ((float)self.displayPhoto.likesNum / [self.maxLike.text floatValue]);
        [self.likesProgress layoutIfNeeded];
    } completion:nil];
    
//    [UIView animateWithDuration:2.0 animations:^{
//        [self.likesProgress layoutIfNeeded];
//        
//    }];
    
    //set commentprogressbar (totalLikes / maxLikes)
    self.commentsProgress.progress = ((float)self.displayPhoto.commentsNum / [self.maxComment.text floatValue]);
    
    [UIView animateWithDuration:2.0 animations:^{
        [self.commentsProgress layoutIfNeeded];
    }];
    
    
    
}

- (void)cleanCell {
    
    self.commentsProgress.progress = 0;
    self.likesProgress.progress = 0;
    
}

-(NSString *)getMaxComments:(NSOrderedSet<Photo *> *)photos {
    NSNumber *max = @(photos[0].commentsNum);
    
    for (int i = 0; i < photos.count; i++) {
        if ([max compare:@(photos[i].commentsNum)] == NSOrderedAscending) {
            max = @(photos[i].commentsNum);
        }
    }
    return [max stringValue];
}

-(NSString *)getMinComments:(NSOrderedSet<Photo *> *)photos {
    NSNumber *min = @(photos[0].commentsNum);
    
    for (int i = 0; i < photos.count; i++) {
        if ([min compare:@(photos[i].commentsNum)] == NSOrderedDescending) {
            min = @(photos[i].commentsNum);
        }
    }
    return [min stringValue];
}

-(NSString *)getMaxLikes:(NSOrderedSet<Photo *> *)photos {
    NSNumber *max = @(photos[0].likesNum);
    
    for (int i = 0; i < photos.count; i++) {
        if ([max compare:@(photos[i].likesNum)] == NSOrderedAscending) {
            max = @(photos[i].likesNum);
        }
    }
    return [max stringValue];
}

-(NSString *)getMinLikes:(NSOrderedSet<Photo *> *)photos {
    NSNumber *min = @(photos[0].likesNum);
    
    for (int i = 0; i < photos.count; i++) {
        if ([min compare:@(photos[i].likesNum)] == NSOrderedDescending) {
            min = @(photos[i].likesNum);
        }
    }
    return [min stringValue];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
