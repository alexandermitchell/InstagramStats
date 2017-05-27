//
//  User+CoreDataProperties.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"User"];
}

@dynamic numOfFollowers;
@dynamic numFollowing;
@dynamic fullName;
@dynamic numOfNewFollowers;
@dynamic numNewFollowing;
@dynamic userID;
@dynamic userName;
@dynamic photos;

@end
