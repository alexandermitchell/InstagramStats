//
//  PostTableViewCell.h
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-31.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo+CoreDataProperties.h"

@interface PostTableViewCell : UITableViewCell

@property (nonatomic) NSOrderedSet <Photo *> *photos;
@property (nonatomic) Photo *displayPhoto;

- (void)cleanCell;
- (void)setMinMaxValues;
- (void)updateCellValues;


@end
