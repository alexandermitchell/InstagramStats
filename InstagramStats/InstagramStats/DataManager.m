//
//  DataManager.m
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "DataManager.h"
#import "User+CoreDataProperties.h"
#import "Photo+CoreDataProperties.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DataManager ()

@end

@implementation DataManager

+(id)sharedManager {
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.engine = [InstagramEngine sharedEngine];
        ;
    });
    return sharedMyManager;
}

//-(User *)currentUser {
//    
//    if (_currentUser == nil) {
//        _currentUser = [[User alloc] initWithContext:self.persistentContainer.viewContext];
//    }
//    
//    return _currentUser;
//}

@synthesize persistentContainer = _persistentContainer;

-(NSPersistentContainer *)persistentContainer {
    
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"InstagramStats"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

-(void)fetchUser:(InstagramUser *)user {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID LIKE[c] %@", user.Id];
    request.predicate = predicate;
    
    NSArray<User *> *users = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    if (users == nil || users.count == 0) {
        [self saveUser:user];
        NSLog(@"made new user");
    } else {
        self.currentUser = users[0];
        NSLog(@"%@", users[0].fullName);
    }

}

-(void) fetchCurrentUser {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray<User *> *users = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    self.currentUser = users[0];
}

-(void)saveUser:(InstagramUser *)user {
    
    User *newUser = [[User alloc] initWithContext:self.persistentContainer.viewContext];
    
    newUser.fullName = user.fullName;
    newUser.username = user.username;
    newUser.followersNum = (int32_t)user.followedByCount;
    newUser.followingNum = (int32_t)user.followsCount;
    newUser.userID = user.Id;

    self.currentUser = newUser;
    [self saveContext];
    NSLog(@"saved user");
}

-(void) savePhotos:(NSArray<InstagramMedia *>*)media withUser:(User *)user {
    
    user.photos = nil;
    [self saveContext];
    for (InstagramMedia *photo in media) {
        [self saveMedia:photo withUser:user];
        
    }
}

-(void) saveMedia:(InstagramMedia *)media withUser:(User *)user {

    Photo *photo = [[Photo alloc] initWithContext:self.persistentContainer.viewContext];
    
    photo.imageURL = [media.standardResolutionImageURL absoluteString];
    photo.likesNum = media.likesCount;
    photo.commentsNum = media.commentCount;
    photo.latitude = media.location.latitude;
    photo.longitude = media.location.longitude;
    photo.postDate = media.createdDate;
    photo.user = user;
    
    NSLog(@"saved photo to core data");
    
    [self downloadImage:media complete:^(UIImage *image) {
        
        photo.image = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"downloaded image");
        [self saveContext];
        
    }];
}

- (void)downloadImage:(InstagramMedia *)media complete:(void (^)(UIImage *image))complete {
    
    NSURLSessionTask *task = [[NSURLSession sharedSession]
                              dataTaskWithURL:media.standardResolutionImageURL
                              completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                  if (error) { abort(); }
                                  
                                  UIImage *loadedImage = [UIImage imageWithData:data];
                                  complete(loadedImage);
                              }];
    [task resume];
}

+(void) loadImage:(NSData *)imageData complete:(void (^)(UIImage *image))complete {
    UIImage *loadedImage = [UIImage imageWithData:imageData];
    complete(loadedImage);
}

-(NSArray<Photo *> *) fetchPhotosWithLocation {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"latitude != 0 AND longitude != 0"];
    
    return [self.persistentContainer.viewContext executeFetchRequest:request error:nil];

}

@end
