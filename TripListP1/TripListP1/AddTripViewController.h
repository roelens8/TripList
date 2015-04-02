//
//  AddTripViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/26/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class TripListViewController;

@interface AddTripViewController : UIViewController

@property TripListViewController *tripListVC;
@property (strong, nonatomic) IBOutlet UITextField *tripNameField;
@property (strong, nonatomic) IBOutlet UIDatePicker *tripDatePicker;

- (IBAction)addTrip:(id)sender;

@end
