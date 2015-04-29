//
//  LoginViewController.h
//  TripListP1
//
//  Created by Jacob Parra on 4/22/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#ifndef TripListP1_LoginViewController_h
#define TripListP1_LoginViewController_h

#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TripList.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;

-(void)waitToLogin;

@end