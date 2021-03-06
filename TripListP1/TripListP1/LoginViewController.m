//
//  LoginViewController.m
//  TripListP1
//
//  Created by Jacob Parra on 4/22/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "TripListViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(UIButton *)sender {
    [PFUser logInWithUsernameInBackground:self.user.text password:self.pass.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"logged in");
                                            [TripList destroy]; //Once logged in, destroy old TripList singleton and create a new one with the current user's data
                                            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            TripListViewController *main = [sb instantiateViewControllerWithIdentifier:@"MainView"]; // @"SettingsListViewController" is the string you have set in above picture
                                            [self.navigationController pushViewController:main animated:YES];
                                        } else {
                                            // The login failed. Check error to see why.
                                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Login failed"
                                                                                           message: [error userInfo][@"error"]
                                                                                          delegate: self
                                                                                 cancelButtonTitle:@"Ok"
                                                                                 otherButtonTitles:nil];
                                            [alert show];
                                            NSLog(@"not logged in");
                                        }
                                    }];
    
}

-(void)waitToLogin {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TripListViewController *main = [sb instantiateViewControllerWithIdentifier:@"MainView"]; // @"SettingsListViewController" is the string you have set in above picture
    [self.navigationController pushViewController:main animated:YES];
}

@end