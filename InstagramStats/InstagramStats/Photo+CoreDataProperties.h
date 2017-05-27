//
//  Photo+CoreDataProperties.h
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "Photo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest;

@property (nonatomic) int16_t numOfLikes;
@property (nonatomic) int16_t numOfComments;
@property (nullable, nonatomic, copy) NSString *imageURLString;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSDate *datePosted;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
