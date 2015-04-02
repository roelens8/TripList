//
//  EditStoreViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripList.h"
#import "Trip.h"

@interface EditStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *currentStore;

- (IBAction)editStore:(id)sender;

@end
