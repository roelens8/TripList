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

@interface EditStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *storeItems; //Store Names - NSString
@property NSMutableArray *filteredStoreItems; //filtered array of groceries for the search bar
@property NSMutableArray *checkedItems; //Shopping List for current Store - GroceryItem

@property (strong, nonatomic) IBOutlet UILabel *currentStore;

@property IBOutlet UISearchBar *itemSearchBar;

- (IBAction)editStore:(id)sender;

@end
