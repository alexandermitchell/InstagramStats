//
//  LoginViewController.h
//  InstagramStats
//
//  Created by Alex Mitchell on 2017-05-29.
//  Copyright © 2017 Alex Mitchell. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegateProtocol

-(void) loginDidSucceed;

@end

@interface LoginViewController : UIViewController

@property (nonatomic) id<LoginDelegateProtocol> delegate;

@end
