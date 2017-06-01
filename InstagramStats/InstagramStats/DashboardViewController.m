//
//  DashboardViewController.m
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-28.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "DashboardViewController.h"
#import "DataManager.h"
#import <InstagramKit.h>
#import <InstagramEngine.h>
#import "User+CoreDataProperties.h"
#import "Photo+CoreDataProperties.h"
#import "LoginViewController.h"
#import "DashboardCollectionViewCell.h"
#import "GraphView.h"
#import "AllPostsViewController.h"
#import "MapViewController.h"

@interface DashboardViewController () <LoginDelegateProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

// Image Wrapper View Outlets

@property (weak, nonatomic) IBOutlet UIView *imageWrapper;

@property (weak, nonatomic) IBOutlet UIView *profileStatsView;

@property (weak, nonatomic) IBOutlet UIImageView *heartImageView;

@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;

@property (weak, nonatomic) IBOutlet UILabel *profileLikesLabel;

@property (weak, nonatomic) IBOutlet UILabel *profileCommentsLabel;

// Other Wraper View Outlets

@property (weak, nonatomic) IBOutlet UIView *buttonWrapper;

@property (weak, nonatomic) IBOutlet UIView *graphWrapper;

// Followers Button Outlets

@property (weak, nonatomic) IBOutlet UIView *followersBtnView;

@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *followersTitleLabel;

// Following Button Outlets
@property (weak, nonatomic) IBOutlet UIView *followingBtnView;

@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *followingTitleLabel;

// All Posts Button Outlets

@property (weak, nonatomic) IBOutlet UIView *allPostsBtnView;

@property (weak, nonatomic) IBOutlet UILabel *allPostsTitleLabel;

// Map Button Outlets

@property (weak, nonatomic) IBOutlet UIView *mapBtnView;

@property (weak, nonatomic) IBOutlet UILabel *mapTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIView *graphView;

@property (nonatomic) DataManager *manager;
@property (nonatomic) InstagramEngine *engine;
@property (nonatomic) NSArray *cellDataArray;


@end

@implementation DashboardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:54/255.0 blue:105/255.0 alpha:1.0]];
    
    self.manager = [DataManager sharedManager];
    //[self.manager.engine logout];

    if (![self.manager.engine isSessionValid]) {
    
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:NO completion:^{
        }];
    } else {
        [self.manager fetchCurrentUser];
        //self.cellDataArray = [self.manager fetchCellArray];
        self.profileImageView.image = [UIImage imageWithData:self.manager.currentUser.photos[0].image];
        self.usernameLabel.text = self.manager.currentUser.username;
        [self setupButtonSubviews];
        
        [self setupGraphView];
        
    }
    
}


- (IBAction)openInstagram:(UIBarButtonItem *)sender {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://camera"];
                           if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
                               [[UIApplication sharedApplication] openURL:instagramURL
                                                                  options:@{UIApplicationOpenURLOptionUniversalLinksOnly: instagramURL}
                                                        completionHandler:nil];
                           }
    
}


#pragma mark LoginDelegateProtocol


-(void)loginDidSucceed {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    self.cellDataArray = [self.manager fetchCellArray];
    self.usernameLabel.text = self.manager.currentUser.username;
    
    self.profileImageView.image = [UIImage imageWithData:self.manager.currentUser.photos[0].image];
    [self setupGraphView];
    //[self.collectionView reloadData];
}

-(void) setupGraphView {
    
    
    GraphView *graphView = [[GraphView alloc] init];
    graphView.frame = self.graphView.bounds;
    [self.graphView addSubview: graphView];
    
    NSMutableArray *likesArray = [NSMutableArray new];
    NSMutableArray *commentsArray = [NSMutableArray new];
    
    for (Photo *photo in self.manager.currentUser.photos) {
        NSNumber *likes = @(photo.likesNum);
        NSNumber *comments = @(photo.commentsNum);
        
        [likesArray addObject:likes];
        [commentsArray addObject:comments];
    }
    
    graphView.likesDataSet = likesArray;
    graphView.commentsDataSet = commentsArray;
    
}

- (IBAction)showFollowers:(UITapGestureRecognizer *)sender {
    
    
}

- (IBAction)showFollowing:(UITapGestureRecognizer *)sender {
    
}

- (IBAction)showAllPosts:(UITapGestureRecognizer *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ShowAllPosts" bundle:nil];
    
    AllPostsViewController *allPostsVC = [storyboard instantiateViewControllerWithIdentifier:@"ShowAllPosts"];
    
    [self.navigationController pushViewController:allPostsVC animated:YES];
    
    
}

- (IBAction)showMap:(UITapGestureRecognizer *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MapViewController *mapVC = [storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    
    [self.navigationController pushViewController:mapVC animated:YES];
    
}

-(void) setupButtonSubviews {
    
    // Followers subview setup
    self.followersBtnView.layer.cornerRadius = self.followersBtnView.bounds.size.width/2;
    self.followersBtnView.layer.masksToBounds = YES;
    self.followersCountLabel.text = [NSString stringWithFormat:@"%d",self.manager.currentUser.followersNum];
    
    // Following subview setup
    
    self.followingBtnView.layer.cornerRadius = self.followingBtnView.bounds.size.width/2;
    self.followingBtnView.layer.masksToBounds = YES;
    self.followingCountLabel.text = [NSString stringWithFormat:@"%d",self.manager.currentUser.followingNum];
    
    // All Posts subview setup
    
    self.allPostsBtnView.layer.cornerRadius = self.allPostsBtnView.bounds.size.width/2;
    self.allPostsBtnView.layer.masksToBounds = YES;
    
    // Map subview setup
    
    self.mapBtnView.layer.cornerRadius = self.mapBtnView.bounds.size.width/2;
    self.mapBtnView.layer.masksToBounds = YES;
    
    // button wrapper border
    
    self.buttonWrapper.layer.borderWidth = 1;
    self.buttonWrapper.layer.borderColor = [UIColor colorWithRed:175.0/255 green:175.0/255 blue:175.0/255 alpha:1.0].CGColor;
    
    //profile stats view
    
    self.profileStatsView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    
    self.profileStatsView.layer.cornerRadius = 4;
    self.profileStatsView.layer.masksToBounds = YES;
    
    self.heartImageView.image = [self.heartImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.heartImageView setTintColor:[UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0]];
    self.profileLikesLabel.text = [NSString stringWithFormat:@"%d", self.manager.currentUser.photos[0].likesNum];
    
    self.commentImageView.image = [self.commentImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.commentImageView setTintColor:[UIColor colorWithRed:120.0/255 green:120.0/255 blue:120.0/255 alpha:1.0]];
    self.profileCommentsLabel.text = [NSString stringWithFormat:@"%d", self.manager.currentUser.photos[0].commentsNum];
    
    
}





@end
