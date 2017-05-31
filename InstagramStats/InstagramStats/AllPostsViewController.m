//
//  AllPostsViewController.m
//  InstagramStats
//
//  Created by Marc Maguire on 2017-05-31.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import "AllPostsViewController.h"
#import "PostTableViewCell.h"
#import "DataManager.h"
#import "User+CoreDataProperties.h"

@interface AllPostsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) DataManager *manager;

@end

@implementation AllPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DataManager sharedManager];
    // Do any additional setup after loading the view.
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

#pragma mark - TableView Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.manager.currentUser.photos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.photos = self.manager.currentUser.photos;
    cell.displayPhoto = self.manager.currentUser.photos[indexPath.row];
    
    return cell;
}

@end
