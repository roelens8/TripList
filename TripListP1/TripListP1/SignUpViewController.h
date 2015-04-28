//
//  SignUpViewController.h
//  TripListP1
//
//  Created by Jacob Parra on 4/22/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#ifndef TripListP1_SignUpViewController_h
#define TripListP1_SignUpViewController_h


#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UITextField *repass;

@end