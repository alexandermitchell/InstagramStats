//
//  User+CoreDataProperties.h
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nonatomic) int32_t numOfFollowers;
@property (nonatomic) int32_t numFollowing;
@property (nullable, nonatomic, copy) NSString *fullName;
@property (nonatomic) int16_t numOfNewFollowers;
@property (nonatomic) int16_t numNewFollowing;
@property (nullable, nonatomic, copy) NSString *userID;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) NSSet<Photo *> *photos;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet<Photo *> *)values;
- (void)removePhotos:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
