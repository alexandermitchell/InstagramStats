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

@interface DashboardViewController () <UICollectionViewDelegate, UICollectionViewDataSource, LoginDelegateProtocol>


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) DataManager *manager;
@property (nonatomic) InstagramEngine *engine;


@end

@implementation DashboardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [DataManager sharedManager];
    [self.manager.engine logout];

    if (![self.manager.engine isSessionValid]) {
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:NO completion:^{
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Collection View Data Source Methods


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardCollectionViewCell"
                                                     forIndexPath:indexPath];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark LoginDelegateProtocol

-(void)loginDidSucceed {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
