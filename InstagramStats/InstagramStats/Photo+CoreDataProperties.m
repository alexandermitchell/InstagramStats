//
//  Photo+CoreDataProperties.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "Photo+CoreDataProperties.h"

@implementation Photo (CoreDataProperties)

+ (NSFetchRequest<Photo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
}

@dynamic numOfLikes;
@dynamic numOfComments;
@dynamic imageURLString;
@dynamic latitude;
@dynamic longitude;
@dynamic datePosted;
@dynamic user;

@end
