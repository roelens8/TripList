//
//  AddStoreViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Trip.h"
#import "TripList.h"
#import "CustomCell.h"
#import "CheckedGroceryItem.h"

@interface AddStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *stores; //Array of all Stores
@property NSMutableArray *storeItems; //Array of Gorceries a store sells
@property NSMutableArray *storeNames; //Array of all Store names
@property NSMutableArray *filteredStoreItems; //Filtered array of groceries for the Search Bar
@property NSString *storePickerSelectedStore; //The store selected form the picker view
@property NSInteger storePickerSelectedRow; //Row of the selected store

@property NSMutableArray *checkedGName; //Array of names of check groceries
@property NSMutableArray *checkedGField; //Array of UITextFields of checked groceries
@property bool first;

@property (strong, nonatomic) IBOutlet UIPickerView *storePicker;
@property (strong, nonatomic) IBOutlet UITableView *addStoreTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *itemSearchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)addStore:(id)sender;
- (IBAction)goToSearch:(id)sender;
- (void)updateQuantityFields:(UITableView*)tableView groceriesArray:(NSMutableArray*)groceries;

@end
