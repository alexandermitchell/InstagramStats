//
//  DashboardCollectionViewCell.m
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "DashboardCollectionViewCell.h"


@interface DashboardCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;


@end

@implementation DashboardCollectionViewCell


-(void)setData:(NSDictionary *)data {
    self.titleLable.text = [data objectForKey:@"title"];
    self.subtitleLabel.text = [data objectForKey:@"subtitle"];
    self.counterLabel.text = [data objectForKey:@"counter"];
    _data = [data objectForKey:@"data"];
}

@end
