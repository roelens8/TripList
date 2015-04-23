//
//  LaunchViewController.m
//  TripListP1
//
//  Created by Jacob Parra on 4/22/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LaunchViewController.h"
#import "TripListViewController.h"

@interface LaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tableView;

@end

@implementation LaunchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
    
    self.tableView.animationImages = [NSArray arrayWithObjects:
                                      
                                      [UIImage imageNamed:@"boxes256.png"],
                                      
                                      [UIImage imageNamed:@"breads256.png"],
                                      
                                      [UIImage imageNamed:@"cans256.png"],
                                      [UIImage imageNamed:@"fruits256.png"],
                                      [UIImage imageNamed:@"meats256.png"],
                                      
                                      [UIImage imageNamed:@"paperbag256.png"], nil];
    
    
    
    
    self.tableView.animationDuration = 3.0;
    self.tableView.animationRepeatCount = 1;
    [self.tableView startAnimating];
    
    
    [NSTimer    scheduledTimerWithTimeInterval:2.6    target:self    selector:@selector(fireMethod)    userInfo:nil repeats:NO];
    
    
}

-(void)fireMethod
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TripListViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end