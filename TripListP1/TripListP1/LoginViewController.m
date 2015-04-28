//
//  LoginViewController.m
//  TripListP1
//
//  Created by Jacob Parra on 4/22/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import <Parse/Parse.h>
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
                                            
                                            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                            TripListViewController *main = [sb instantiateViewControllerWithIdentifier:@"MainView"]; // @"SettingsListViewController" is the string you have set in above picture
                                           // [self.navigationController popToViewController:main animated:YES];
                                            
                                            [self.navigationController pushViewController:main animated:YES];



                                            
                                            
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"not logged in");
                                        }
                                    }];
    
}

@end