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

@property (nonatomic) NSMutableArray *likesDataset;
@property (nonatomic) NSMutableArray *commentsDataset;



@end

@implementation DashboardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:54/255.0 blue:105/255.0 alpha:1.0]];
    
    self.manager = [DataManager sharedManager];
    // [self.manager.engine logout];

    if (![self.manager.engine isSessionValid]) {
        
    
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:YES completion:^{
        }];
        
        
        
    } else {
        
        [self.manager fetchCurrentUser];
        
        self.profileImageView.image = [UIImage imageWithData:self.manager.currentUser.photos[3].image];
        self.usernameLabel.text = self.manager.currentUser.username;
        [self setupButtonSubviews];
        
        [self setupGraphView];
        [self setupAnimatedBezierPaths];
        
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
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.usernameLabel.text = self.manager.currentUser.username;
        
        self.profileImageView.image = [UIImage imageWithData:self.manager.currentUser.photos[0].image];
        [self setupGraphView];
        [self setupButtonSubviews];
        [self setupAnimatedBezierPaths];
    }];
  
}

-(void) setupGraphView {
    
    
//    GraphView *graphView = [[GraphView alloc] init];
//    graphView.frame = self.graphView.bounds;
//    [self.graphView addSubview: graphView];
    
    NSMutableArray *likesArray = [NSMutableArray new];
    NSMutableArray *commentsArray = [NSMutableArray new];
    
    for (Photo *photo in self.manager.currentUser.photos) {
        NSNumber *likes = @(photo.likesNum);
        NSNumber *comments = @(photo.commentsNum);
        
        [likesArray addObject:likes];
        [commentsArray addObject:comments];
    }
    
    self.likesDataset = likesArray;
    self.commentsDataset = commentsArray;
    
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

#pragma mark - Bezier Path methods


-(UIBezierPath *)bezierPathForDataset:(NSArray *)dataset {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGFloat maxData = [DashboardViewController getMax:dataset];
    CGFloat minData = [DashboardViewController getMin:dataset];
    
    CGFloat partitionWidth = self.graphView.bounds.size.width / (dataset.count + 1);
    
    [path moveToPoint:CGPointMake(0, [self getHeightForData:dataset[0]
                                                  WithinMin:minData
                                                     andMax:maxData])];
    
    for (int i = 1; i < dataset.count; i++) {
        CGPoint p = CGPointMake((i - 1) * partitionWidth, [self getHeightForData:dataset[i - 1]
                                                                       WithinMin:minData
                                                                          andMax:maxData]);
        CGPoint q = CGPointMake(i * partitionWidth, [self getHeightForData:dataset[i]
                                                                 WithinMin:minData
                                                                    andMax:maxData]);
        
        CGPoint midpoint = [DashboardViewController getMidpointBetween:p and:q];
        CGPoint controlPoint1 = [DashboardViewController getControlPointFor:midpoint and:p];
        CGPoint controlPoint2 = [DashboardViewController getControlPointFor:midpoint and:q];
        
        [path addQuadCurveToPoint:midpoint controlPoint:controlPoint1];
        [path addQuadCurveToPoint:q controlPoint:controlPoint2];
    }
    
    return path;
}


#pragma mark - Bezier Path Animation methods


-(void)setupLikesAnimationBezierPath {
    [self setupAnimatedBezierPathWithDataset:self.likesDataset andColor:[UIColor colorWithRed:236/255.0 green:0 blue:98/255.0 alpha:1.0]];
}

-(void)setupCommentsAnimationBezierPath {
    [self setupAnimatedBezierPathWithDataset:self.commentsDataset andColor:[UIColor colorWithRed:0 green:148/255.0 blue:236/255.0 alpha:1.0]];
}

-(void)setupAnimatedBezierPaths {
    [self setupLikesAnimationBezierPath];
    [self setupCommentsAnimationBezierPath];
    NSLog(@"Finished setupAnimatedBezierPaths");
}

-(void)setupAnimatedBezierPathWithDataset:(NSArray *)dataset andColor:(UIColor *)color {
    
    UIBezierPath *bezierPath = [self bezierPathForDataset:dataset];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = CGRectMake(0, 0, self.graphView.frame.size.width * .8, self.graphView.frame.size.height * .8);
    //shapelayer.frame = self.graphView.bounds;
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


#pragma mark - Utility Geometric Methods


+(CGPoint)getMidpointBetween:(CGPoint)p and:(CGPoint)q {
    return CGPointMake((p.x + q.x) / 2, (p.y + q.y) / 2);
}

+(CGPoint)getControlPointFor:(CGPoint)p and:(CGPoint)q {
    CGPoint controlPoint = [DashboardViewController getMidpointBetween:p and:q];
    CGFloat diffY = fabs(q.y - controlPoint.y);
    
    controlPoint.y += (p.y < q.y) ? +diffY : -diffY;
    
    return controlPoint;
}

-(CGFloat)getHeightForData:(NSNumber *)data WithinMin:(CGFloat)min andMax:(CGFloat)max {
    if (max == min) {
        return 0;
    }
    
    CGFloat c = ([data doubleValue] - min) / (max - min);
    return self.graphView.frame.size.height * (1 - c);
}


#pragma mark - NSArray Utility Functions


+(CGFloat)getMax:(NSArray<NSNumber *> *)dataset {
    NSNumber *max = dataset[0];
    
    for (int i = 0; i < dataset.count; i++) {
        if ([max compare:dataset[i]] == NSOrderedAscending) {
            max = dataset[i];
        }
    }
    return [max doubleValue];
}

+(CGFloat)getMin:(NSArray<NSNumber *> *)dataset {
    NSNumber *min = dataset[0];
    
    for (int i = 0; i < dataset.count; i++) {
        if ([min compare:dataset[i]] == NSOrderedDescending) {
            min = dataset[i];
        }
    }
    return [min doubleValue];
}





@end
