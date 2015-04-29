//
//  SignUpViewController.m
//  TripListP1
//
//  Created by Jacob Parra on 4/22/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "SignUpViewController.h"
#import "LoginViewController.h"

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(UIButton *)sender {
    
    //[self checkFieldsComplete];
    if([self.email.text isEqualToString:@""] || [self.pass.text isEqualToString:@""] || [self.repass.text isEqualToString:@""] || [self.username.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Registration failed"
                                                       message: @"You need to complete all fields"
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else {
        if(![self.pass.text isEqualToString:self.repass.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Registration failed"
                                                           message: @"Passwords do not match"
                                                          delegate: self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
            [alert show];
            
        }
        else {
            PFUser *user = [PFUser user];
            user.username = self.username.text;
            user.password = self.pass.text;
            user.email = self.email.text;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Reigstration successful");
                    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    LoginViewController *login = [sb instantiateViewControllerWithIdentifier:@"LoginView"]; // @"SettingsListViewController" is the string you have set in above picture
                    // [self.navigationController popToViewController:main animated:YES];
                    [self.navigationController pushViewController:login animated:YES];
                }
                else {
                    NSLog(@"Registration failed");
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Registration failed"
                                                                   message: [error userInfo][@"error"]
                                                                  delegate: self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }
}

@end