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
#import "CustomCell.h"

@interface AddStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property NSMutableArray *stores; //Array of all Stores
@property NSMutableArray *storeItems; //Array of Gorceries a store sells
@property NSMutableArray *storeNames; //Array of all Store names
@property NSMutableArray *checkedGroceries; //Array containing strings that concatenate all grocery data
@property NSMutableArray *checkedCellRows; //Indexes of cells of the groceries the user selected
@property NSString *storePickerSelectedStore; //The store selected form the picker view
@property NSInteger storePickerSelectedRow; //Row of the selected store
@property (strong, nonatomic) IBOutlet UIPickerView *storePicker;


- (IBAction)addStore:(id)sender;
- (void)saveTripData;

@end
