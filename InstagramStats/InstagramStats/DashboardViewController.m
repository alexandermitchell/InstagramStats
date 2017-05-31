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
#import "LoginViewController.h"
#import "DashboardCollectionViewCell.h"
#import "GraphView.h"

@interface DashboardViewController () <UICollectionViewDelegate, UICollectionViewDataSource, LoginDelegateProtocol>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) DataManager *manager;
@property (nonatomic) InstagramEngine *engine;
@property (nonatomic) NSArray *cellDataArray;

@property (nonatomic) NSMutableArray *likesDataset;
@property (nonatomic) NSMutableArray *commentsDataset;

@end

@implementation DashboardViewController

//-(NSArray *)cellDataArray {
//    if (_cellDataArray == nil) {
//        _cellDataArray = [self.manager fetchCellArray];
//    }
//    return _cellDataArray;
//}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [DataManager sharedManager];
    [self.manager.engine logout];

    if (![self.manager.engine isSessionValid]) {
    
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:NO completion:^{
        }];
    }

    self.graphView.backgroundColor = [UIColor blackColor];
    GraphView *graphView = [[GraphView alloc] init];
    graphView.frame = self.graphView.bounds;
    [self.graphView addSubview: graphView];
}


#pragma mark - Collection View Data Source Methods


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellDataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardCollectionViewCell" forIndexPath:indexPath];
    cell.data = self.cellDataArray[indexPath.row];
    
    return cell;
}

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
    [self.collectionView reloadData];
}

@end
