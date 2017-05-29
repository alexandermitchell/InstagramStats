//
//  ViewController.m
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-27.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import <InstagramKit.h>
#import <InstagramEngine.h>
#import "User+CoreDataProperties.h"

<<<<<<< HEAD

@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak) InstagramUser *myUser;
=======
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
>>>>>>> 58bba43c70864af1c1afe000075f6e9e54b9a708

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    InstagramKitLoginScope scope = InstagramKitLoginScopeRelationships | InstagramKitLoginScopeComments | InstagramKitLoginScopeLikes | InstagramKitLoginScopePublicContent | InstagramKitLoginScopeFollowerList;
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:scope];
    [self.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    
    self.webView.delegate = self;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

<<<<<<< HEAD
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"%@", webView.request.URL);
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error]) {
        
        
        //DataManager *manager = [DataManager sharedManager];
        //User *theUser = [[User alloc] initWithContext:manager.persistentContainer.viewContext];
        
        
        
        NSLog(@"Received access token: %@", [[InstagramEngine sharedEngine] accessToken]);
        
        [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
            
                self.myUser = user;
            
//            theUser.fullName = user.fullName;
//            theUser.userID = user.Id;
//            theUser.followersNum = (int32_t)user.followedByCount;
//            theUser.followingNum = (int32_t)user.followsCount;
//            
//            [manager saveContext];
            
            NSLog(@"username: %@", user.username);
            
            [[InstagramEngine sharedEngine] getMediaForUser:self.myUser.Id withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
                
                NSLog(@"test user %@", media[0].lowResolutionImageURL);
                
                [[InstagramEngine sharedEngine] getLikesOnMedia:media[0].Id withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
                    NSLog(@"users: %@", users[0].fullName);
                } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                    
                }];
                
            } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                
            }];
            
            
            
            
        } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
            return;
            
        }];
    
    
        
        //[self performSegueWithIdentifier:@"toMain" sender:nil];
        
    }
    return YES;
}

//https://www.instagram.com/p/BT2cBFHjAF5/


=======
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                           forIndexPath:indexPath];
    NSLog(@"%@", [cell class]);
    return cell;
}
>>>>>>> 58bba43c70864af1c1afe000075f6e9e54b9a708

@end
