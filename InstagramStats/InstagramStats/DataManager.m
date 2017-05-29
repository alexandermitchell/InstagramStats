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

-(instancetype) init {
    if (self = [super init]) {
    }
    return self;
}

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

-(User *)currentUser {
    
    if (_currentUser == nil) {
        _currentUser = [[User alloc] initWithContext:self.persistentContainer.viewContext];
    }
    
    return _currentUser;
}

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

-(NSArray<User *> *)fetchUser {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSArray<User *> *users = [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    NSLog(@"%@", users[0].fullName);
    
    self.currentUser = users[0];
    
    return users;
    
}

-(void)saveUser:(InstagramUser *)user {

    self.currentUser.fullName = user.fullName;
    self.currentUser.username = user.username;
    self.currentUser.followersNum = (int32_t)user.followedByCount;
    self.currentUser.followingNum = (int32_t)user.followsCount;
    self.currentUser.userID = user.Id;
    
    
    [self saveContext];
    
    NSLog(@"saved user");
    
}

-(void) savePhotos:(NSArray<InstagramMedia *>*)media withUser:(User *)user {
    
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
    photo.user = user;
    
    NSLog(@"saved photo to core data");
    
    [self downloadImage:media complete:^(UIImage *image) {
        photo.image = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"downloaded image");
        [self saveContext];
    }];
    
    [self saveContext];
    
}

- (void)downloadImage:(InstagramMedia *)media complete:(void (^)(UIImage *image))complete
{
    
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

@end
