//
//  AddStoreViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Trip.h"
#import "TripList.h"

@interface AddStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property NSMutableArray *stores;
@property NSMutableArray *storeNames;
@property NSMutableArray *storeItems;
@property (strong, nonatomic) IBOutlet UIPickerView *storePicker;

- (IBAction)addStore:(id)sender;

@end
