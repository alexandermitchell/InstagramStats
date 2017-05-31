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
//    [self.manager.engine logout];

//    if (![self.manager.engine isSessionValid]) {
//    
//        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//        loginVC.delegate = self;
//        [self presentViewController:loginVC animated:NO completion:^{
//        }];
//    }

    [self setupGraphView];


//    if (![self.manager.engine isSessionValid]) {
//    
//        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//        loginVC.delegate = self;
//        [self presentViewController:loginVC animated:NO completion:^{
//        }];
//    }

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
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)openInstagram:(UIBarButtonItem *)sender {
    
    
}


#pragma mark LoginDelegateProtocol


-(void)loginDidSucceed {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    self.cellDataArray = [self.manager fetchCellArray];
    [self.collectionView reloadData];
}

-(void) setupGraphView {
    
    self.graphView.backgroundColor = [UIColor blackColor];
    GraphView *graphView = [[GraphView alloc] init];
    graphView.frame = CGRectMake(10, 10, self.graphView.frame.size.width * 0.8, self.graphView.frame.size.height * 0.8);
    graphView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.graphView addSubview: graphView];
    
    NSMutableArray *likesArray = [NSMutableArray new];
    NSMutableArray *commentsArray = [NSMutableArray new];

//    [self.manager.currentUser.photos sortedArrayUsingComparator:^NSComparisonResult(Photo *a, Photo *b) {
//        return [a.postDate compare:b.postDate];
//    }];
//    
//    for (Photo *photo in self.manager.currentUser.photos) {
//        NSNumber *likes = @(photo.likesNum);
//        NSNumber *comments = @(photo.commentsNum);
//        
//        [likesArray addObject:likes];
//        [commentsArray addObject:comments];
//    }
//    graphView.likesDataSet = likesArray;
//    graphView.commentsDataSet = commentsArray;
    
}

@end
