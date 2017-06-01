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

    UIBezierPath *bezierPath = [self bezierPathForDataset:dataset];

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
