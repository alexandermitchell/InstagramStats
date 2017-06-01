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

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
        
        
        [self setupGraphView];
        
    }
    
}


#pragma mark - Collection View Data Source Methods


//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.cellDataArray.count;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    DashboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardCollectionViewCell" forIndexPath:indexPath];
//    cell.data = self.cellDataArray[indexPath.row];
//    
//    cell.layer.masksToBounds = YES;
//    cell.layer.cornerRadius = 10;
//    
//    return cell;
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.row) {
//        case 2: {
//            
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ShowAllPosts" bundle:nil];
//            
//            
//            AllPostsViewController *apVC = [storyboard instantiateViewControllerWithIdentifier:@"ShowAllPosts"];
//            
//            [self.navigationController pushViewController:apVC animated:YES];
//            
//            break;
//        }
//            
//        case 3: {
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            MapViewController *mapVC = [storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
//            
//            [self.navigationController pushViewController:mapVC animated:YES];
//            break;
//        }
//            
//        default:
//            break;
//    }
//}

/*
 #pragma mark - Navigation
 
  In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  Get the new view controller using [segue destinationViewController].
  Pass the selected object to the new view controller.
 }
 */

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

@end
