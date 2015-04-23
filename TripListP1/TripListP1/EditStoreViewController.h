//
//  EditStoreViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TripList.h"
#import "Trip.h"
#import "CustomCell.h"
#import "GroceryItem.h"
#import "CheckedGroceryItem.h"

@interface EditStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property NSMutableArray *storeItems; //Store Names - NSString
@property NSMutableArray *checkedItems; //Shopping List for current Store - GroceryItem
@property NSMutableDictionary *quantityFieldMap; ////If quantity was changed after checking the grocery item

@property (strong, nonatomic) IBOutlet UILabel *currentStore;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)editStore:(id)sender;

@end
