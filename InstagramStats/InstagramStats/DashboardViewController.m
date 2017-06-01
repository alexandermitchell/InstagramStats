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
    graphView.frame = CGRectMake(25, 25, self.graphView.frame.size.width * 0.95, self.graphView.frame.size.height * 0.8);
    graphView.layer.borderColor = [UIColor whiteColor].CGColor;
    graphView.layer.borderWidth = 2.0;
    [self.graphView addSubview: graphView];

    UILabel *oldLabel = [[UILabel alloc] initWithFrame:CGRectMake(3,
                                                                  3,
                                                                  100,
                                                                  100)];
    oldLabel.text = @"older";
    oldLabel.textColor = [UIColor whiteColor];
    [self.graphView addSubview:oldLabel];
    [oldLabel sizeToFit];

    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.graphView.frame.size.width - 10,
                                                                  3,
                                                                  100,
                                                                  100)];
    newLabel.text = @"newer";
    newLabel.textColor = [UIColor whiteColor];
    [self.graphView addSubview:newLabel];
    [newLabel sizeToFit];

    CGFloat minLikes = [GraphView getMin:graphView.likesDataSet];
    CGFloat maxLikes = [GraphView getMax:graphView.likesDataSet];

    UILabel *maxLikesLabel = [[UILabel alloc] init];
    maxLikesLabel.text = [@(maxLikes) description];
    maxLikesLabel.font = [UIFont fontWithName:@"ArialMT" size:15.0];
    maxLikesLabel.textColor = [UIColor redColor];

    [self.graphView addSubview:maxLikesLabel];
    maxLikesLabel.frame = CGRectMake(3,
                                     oldLabel.frame.size.height,
                                     10,
                                     10);
    [maxLikesLabel sizeToFit];

    UITextView *likesTextView = [[UITextView alloc] init];
    likesTextView.textColor = [UIColor redColor];
    likesTextView.font = [UIFont fontWithName:@"ArialMT" size:10.0];
    likesTextView.text = @"L \nI \nK \nE \nS ";
    likesTextView.backgroundColor = [UIColor blackColor];
    likesTextView.frame = CGRectMake(3,
                                     maxLikesLabel.frame.origin.y + maxLikesLabel.frame.size.height,
                                     20,
                                     20);
    [likesTextView sizeToFit];
    [self.graphView addSubview:likesTextView];

    UILabel *minLikesLabel = [[UILabel alloc] init];
    minLikesLabel.text = [@(minLikes) description];
    minLikesLabel.font = [UIFont fontWithName:@"ArialMT" size:15.0];
    minLikesLabel.textColor = [UIColor redColor];

    [self.graphView addSubview:minLikesLabel];
    minLikesLabel.frame = CGRectMake(3,
                                     likesTextView.frame.origin.y + likesTextView.frame.size.height,
                                     10,
                                     10);
    [minLikesLabel sizeToFit];


    CGFloat minComments = [GraphView getMin:graphView.commentsDataSet];
    CGFloat maxComments = [GraphView getMax:graphView.commentsDataSet];

    UILabel *maxCommentsLabel = [[UILabel alloc] init];
    maxCommentsLabel.text = [@(maxComments) description];
    maxCommentsLabel.font = [UIFont fontWithName:@"ArialMT" size:15.0];
    maxCommentsLabel.textColor = [UIColor blueColor];

    [self.graphView addSubview:maxCommentsLabel];
    maxCommentsLabel.frame = CGRectMake(newLabel.frame.origin.x + 20,
                                     newLabel.frame.size.height,
                                     10,
                                     10);
    [maxCommentsLabel sizeToFit];

    UITextView *commentsTextView = [[UITextView alloc] init];
    commentsTextView.textColor = [UIColor blueColor];
    commentsTextView.font = [UIFont fontWithName:@"ArialMT" size:10.0];
    commentsTextView.text = @"C\no\nm\nm\ne\nn\nt\ns";
    commentsTextView.backgroundColor = [UIColor blackColor];
    commentsTextView.frame = CGRectMake(newLabel.frame.origin.x + 20,
                                     maxCommentsLabel.frame.origin.y + maxCommentsLabel.frame.size.height,
                                     20,
                                     20);
    [commentsTextView sizeToFit];
    [self.graphView addSubview:commentsTextView];

    UILabel *minCommentsLabel = [[UILabel alloc] init];
    minCommentsLabel.text = [@(minComments) description];
    minCommentsLabel.font = [UIFont fontWithName:@"ArialMT" size:15.0];
    minCommentsLabel.textColor = [UIColor blueColor];

    [self.graphView addSubview:minCommentsLabel];
    minCommentsLabel.frame = CGRectMake(newLabel.frame.origin.x + 20,
                                     commentsTextView.frame.origin.y + commentsTextView.frame.size.height,
                                     10,
                                     10);
    [minCommentsLabel sizeToFit];

    
//    NSMutableArray *likesArray = [NSMutableArray new];
//    NSMutableArray *commentsArray = [NSMutableArray new];
//
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
