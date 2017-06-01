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
#import "UIBezierPath+Statistics.h"

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
    //[self.manager.engine logout];
    
//    if (![self.manager.engine isSessionValid]) {
//    
//        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//        loginVC.delegate = self;
//        [self presentViewController:loginVC animated:NO completion:^{
//        }];
//    }

    [self setupAnimatedBezierPaths];
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


#pragma mark - Bezier Path Animation methods


-(void)setupLikesAnimationBezierPath {
    [self setupAnimatedBezierPathWithDataset:self.likesDataset andColor:[UIColor redColor]];
}

-(void)setupCommentsAnimationBezierPath {
    [self setupAnimatedBezierPathWithDataset:self.commentsDataset andColor:[UIColor blueColor]];
}

-(void)setupAnimatedBezierPaths {
    [self setupLikesAnimationBezierPath];
    [self setupCommentsAnimationBezierPath];
}

-(void)setupAnimatedBezierPathWithDataset:(NSArray *)dataset andColor:(UIColor *)color {

    UIBezierPath *bezierPath = [UIBezierPath bezierPathForDataset:dataset
                                               withPartitionWidth:self.graphView.bounds.size.width / (dataset.count + 1)
                                                        andHeight:self.graphView.frame.size.height];

    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = self.graphView.bounds;
    shapelayer.path = bezierPath.CGPath;
    [self.graphView.layer addSublayer:shapelayer];

    shapelayer.strokeColor = color.CGColor;
    shapelayer.lineWidth = 5.0;
    shapelayer.fillColor = [UIColor colorWithWhite:1 alpha:0].CGColor;

    shapelayer.strokeStart = 0.0;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 4.0;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);

    [shapelayer addAnimation:animation forKey:@"animation"];
}

@end
