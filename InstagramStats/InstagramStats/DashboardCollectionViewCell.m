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
    self.titleLable = [data objectForKey:@"title"];
    self.counterLabel = [data objectForKey:@"data"];
    
    _data = data;
}

@end
