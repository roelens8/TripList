//
//  EditStoreViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TripList.h"
#import "Trip.h"
#import "CustomCell.h"
#import "GroceryItem.h"
#import "CheckedGroceryItem.h"

@interface EditStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *storeItems; //All Store Item names - NSString
@property NSMutableArray *checkedItems; //Shopping List for current Store - GroceryItem
@property NSMutableDictionary *quantityFieldMap; //Key: Grocery name; Value: Grocery quantity; If quantity was changed after checking the grocery item
@property NSMutableArray *filteredStoreItems; //Filtered array of groceries for the Search Bar

@property (strong, nonatomic) IBOutlet UILabel *currentStore;
@property (strong, nonatomic) IBOutlet UILabel *storeTotal;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *itemSearchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property bool first;

- (IBAction)goToSearch:(id)sender;
- (IBAction)editStore:(id)sender;
- (void)calculateStoreTotal:(TripList*)tripList;

@end
