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
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        
        loginVC.delegate = self;
        [self presentViewController:loginVC animated:NO completion:^{
        }];
    }
}

//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    if (self.manager != nil && self.manager.currentUser != nil) {
//        self.cellDataArray = [self.manager fetchCellArray];
//        
//        
//        [self.collectionView reloadData];
//    }
//}

#pragma mark - Collection View Data Source Methods


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellDataArray.count;
}

//TODO: LOOK UP NSOPTIONS
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DashboardCollectionViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            //followers Dict
            cell.index = indexPath.row;
            cell.data = self.cellDataArray[0];
           
            
            break;
        case 1:
            //following dict
            cell.index = indexPath.row;
            cell.data = self.cellDataArray[1];
            
            break;
            
        case 2:
            //all photos dict
            cell.index = indexPath.row;
            cell.data = self.cellDataArray[2];
            
            break;
        case 3:
            //photos with valid location dict
            cell.index = indexPath.row;
            cell.data = self.cellDataArray[3];
            
            break;
            
        default:
            break;
    }
//    [self.collectionView reloadData];

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


@end
