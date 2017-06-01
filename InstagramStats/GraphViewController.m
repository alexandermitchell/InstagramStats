//
//  GraphViewController.m
//  
//
//  Created by atfelix on 2017-06-01.
//
//

#import "GraphViewController.h"

#import "UIBezierPath+Statistics.h"
#import "Photo+CoreDataProperties.h"



static UIColor *likesColor;
static UIColor *commentsColor;


@interface GraphViewController ()

@property (weak, nonatomic) IBOutlet UIView *engagementView;
@property (weak, nonatomic) IBOutlet UIView *punchCardView;
@property (weak, nonatomic) IBOutlet UIView *hinstogramView;
@property (weak, nonatomic) IBOutlet UISlider *combineSlider;
@property (nonatomic) UIColor *currentColor;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    likesColor = [UIColor redColor];
    commentsColor = [UIColor blueColor];
    self.combineSlider.tintColor = [self getCombinedColor];
    [self setupAnimatedEngagementCurve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)sliderChanged:(UISlider *)sender {
    sender.tintColor = [self getCombinedColor];
}


#pragma mark - Utility functions


-(UIColor *)getCombinedColor {
    CGFloat lambda = self.combineSlider.value;

    CGFloat likesRed, likesGreen, likesBlue, likesAlpha;
    [likesColor getRed:&likesRed green:&likesGreen blue:&likesBlue alpha:&likesAlpha];

    CGFloat commentsRed, commentsGreen, commentsBlue, commentsAlpha;
    [commentsColor getRed:&commentsRed green:&commentsGreen blue:&commentsBlue alpha:&commentsAlpha];

    return [UIColor colorWithRed:[GraphViewController combineHue:likesRed withHue:commentsRed andLambda:lambda]
                           green:[GraphViewController combineHue:likesGreen withHue:commentsGreen andLambda:lambda]
                            blue:[GraphViewController combineHue:likesBlue withHue:commentsBlue andLambda:lambda]
                           alpha:1.0];
}

+(CGFloat)combineHue:(CGFloat)hue1 withHue:(CGFloat)hue2 andLambda:(CGFloat)lambda {
    return (1 - lambda) * hue1 + lambda * hue2;
}

-(UIBezierPath *)getCombinedBezierPathFor:(NSArray *)dataset1 and:(NSArray *)dataset2 andLambda:(CGFloat)lambda {
    return [UIBezierPath bezierPathForDataset:[GraphViewController combine:dataset1
                                                                       and:dataset2
                                                                withLambda:lambda]
                           withPartitionWidth:self.view.frame.size.width / (dataset1.count + 1)
                                    andHeight:self.view.frame.size.height];
}

+(NSArray *)combine:(NSArray *)dataset1 and:(NSArray *)dataset2 withLambda:(CGFloat) lambda {
    NSMutableArray *combinedDataset = [@[] mutableCopy];

    if (dataset1.count != dataset2.count) {
        return @[];
    }

    for (int i = 0; i < dataset1.count; i++) {
        [combinedDataset addObject:@([UIBezierPath combineX:dataset1[i]
                                                       andY:dataset2[i]
                                                 withLambda:lambda])];
    }

    return [combinedDataset copy];
}

-(void)setupAnimatedEngagementCurve {

    NSArray *combinedStats = [self getUserCombinedStats];

    UIBezierPath *bezierPath = [UIBezierPath bezierPathForDataset:combinedStats
                                               withPartitionWidth:self.view.bounds.size.width / (combinedStats.count + 1)
                                                        andHeight:self.view.frame.size.height];

    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = self.engagementView.bounds;
    shapelayer.path = bezierPath.CGPath;
    [self.engagementView.layer addSublayer:shapelayer];

    shapelayer.strokeColor = [self getCombinedColor].CGColor;
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

-(NSArray *)getUserLikeStats {

    NSMutableArray *likesStats = [@[] mutableCopy];
    for (Photo *photo in self.user.photos) {
        [likesStats addObject:@(photo.likesNum)];
    }
    return [likesStats copy];
}

-(NSArray *)getUserCommentStats {

    NSMutableArray *commentStats = [@[] mutableCopy];
    for (Photo *photo in self.user.photos) {
        [commentStats addObject:@(photo.commentsNum)];
    }
    return [commentStats copy];
}

-(NSArray *)getUserCombinedStats {
    return [GraphViewController combine:[self getUserLikeStats]
                                    and:[self getUserCommentStats]
                             withLambda:self.combineSlider.value];
}

-(NSArray *)getFakeData {
    NSMutableArray *fake = [@[] mutableCopy];
    for (int i = 0; i < 20; i++) {
        [fake addObject:@(arc4random_uniform(30) + 10)];
    }
    return [fake copy];
}

@end
