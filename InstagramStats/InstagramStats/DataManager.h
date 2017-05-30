//
//  DataManager.h
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <InstagramKit.h>

@import CoreData;

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic) User *currentUser;
@property (nonatomic) InstagramEngine *engine;


#pragma mark - Instance methods


-(void)saveContext;
-(void) saveUser:(InstagramUser *)user;
-(void) savePhotos:(NSArray<InstagramMedia *>*)media withUser:(User *)user;
-(void) saveMedia:(InstagramMedia *)media withUser:(User *)user;
-(NSArray<User *> *) fetchUser;
-(NSArray *) fetchCellArray;


#pragma mark - Class methods


+(id)sharedManager;
+(void) loadImage:(NSData *)imageData complete:(void (^)(UIImage *image))complete;

@end
