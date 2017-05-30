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
    
    if (self.index < 2) {
    
        self.titleLable.text = [data objectForKey:@"title"];
        self.counterLabel.text = [NSString stringWithFormat:@"%@",[data objectForKey:@"data"]];
    } else if (self.index == 2){
        self.titleLable.text = [data objectForKey:@"title"];
        self.counterLabel.text = [NSString stringWithFormat:@"%lu", [[data objectForKey:@"data"] count]];
    } else {
        self.titleLable.text = [data objectForKey:@"title"];
    }
    _data = data;
}

@end
