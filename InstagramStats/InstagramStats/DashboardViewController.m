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
    //[self.manager.engine logout];
    
//    if (![self.manager.engine isSessionValid]) {
//    
//        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
//        loginVC.delegate = self;
//        [self presentViewController:loginVC animated:NO completion:^{
//        }];
//    }

    // No Animation

    self.graphView.backgroundColor = [UIColor blackColor];
    GraphView *graphView = [[GraphView alloc] init];
    graphView.frame = self.graphView.bounds;
    [self.graphView addSubview: graphView];

    // Animation

//    UIBezierPath *likesBezierPath = [self bezierPathForLikes];
//    UIBezierPath *commentsBezierPath = [self bezierPathForComments];


//    [likesBezierPath appendPath:commentsBezierPath];
//
//    CAShapeLayer *likesShapeLayer = [CAShapeLayer layer];
//    CAShapeLayer *commentsShapeLayer = [CAShapeLayer layer];
//
//    likesShapeLayer.frame = self.graphView.bounds;
//    commentsShapeLayer.frame = self.graphView.bounds;
//
//    likesShapeLayer.path = likesBezierPath.CGPath;
//    commentsShapeLayer.path = commentsBezierPath.CGPath;
//
//    [self.graphView.layer addSublayer:likesShapeLayer];
//    [self.graphView.layer addSublayer:commentsShapeLayer];
//
//    likesShapeLayer.strokeColor = [UIColor blueColor].CGColor;
//    likesShapeLayer.lineWidth = 5.0;
//
//    commentsShapeLayer.strokeColor = [UIColor redColor].CGColor;
//    commentsShapeLayer.lineWidth = 5.0;

//    likesShapeLayer.strokeStart = 0.0;
//    commentsShapeLayer.strokeStart = 0.0;
//
//
//
//    CABasicAnimation *likesAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    likesAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    likesAnimation.duration = 4.0;
//    likesAnimation.fromValue = @(0.0);
//    likesAnimation.toValue = @(1.0);
//
//    [likesShapeLayer addAnimation:likesAnimation forKey:@"likesAnimation"];
//
//    CABasicAnimation *commentsAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    commentsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    commentsAnimation.duration = 4.0;
//    commentsAnimation.fromValue = @(0.0);
//    commentsAnimation.toValue = @(1.0);
//
//    [likesShapeLayer addAnimation:commentsAnimation forKey:@"commentsA nimation"];
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


#pragma mark - Statistics curves

-(NSMutableArray *)likesDataset {
    if (!_likesDataset) {
        _likesDataset = [[NSMutableArray alloc] init];
        for (int i = 0; i < 20; i++) {
            [_likesDataset addObject:@(arc4random_uniform(30) + 10)];
        }
    }
    return _likesDataset;
}

-(NSMutableArray *)commentsDataset {
    if (!_commentsDataset) {
        _commentsDataset = [[NSMutableArray alloc] init];
        for (int i = 0; i < 20; i++) {
            [_commentsDataset addObject:@(arc4random_uniform(10))];
        }
    }
    return _commentsDataset;
}


-(UIBezierPath *)bezierPathForLikes {
    return [self bezierPathForDataset:self.likesDataset withColor:[UIColor blueColor]];
}

-(UIBezierPath *)bezierPathForComments {
    return [self bezierPathForDataset:self.commentsDataset withColor:[UIColor redColor]];
}

-(UIBezierPath *)bezierPathForDataset:(NSArray *)dataset withColor:(UIColor *)color {
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
    //NSLog(@"%@: %@", @(__FUNCTION__), @(self.frame.size.height * (1 - c)));
    return self.graphView.frame.size.height * (1 - c);
}


@end
