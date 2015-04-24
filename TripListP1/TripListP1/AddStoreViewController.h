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
#import "CheckedGroceryItem.h"

@interface AddStoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *stores; //Array of all Stores
@property NSMutableArray *storeItems; //Array of Gorceries a store sells
@property NSMutableArray *storeNames; //Array of all Store names
@property NSMutableArray *checkedGroceries; //Array containing strings that concatenate all grocery data
@property NSMutableArray *checkedCellRows; //Indexes of cells of the groceries the user selected
@property NSMutableArray *filteredStoreItems; //Filtered array of groceries for the Search Bar
@property NSString *storePickerSelectedStore; //The store selected form the picker view
@property NSInteger storePickerSelectedRow; //Row of the selected store

@property (strong, nonatomic) IBOutlet UIPickerView *storePicker;
@property (strong, nonatomic) IBOutlet UITableView *addStoreTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *itemSearchBar;

- (IBAction)addStore:(id)sender;
- (IBAction)goToSearch:(id)sender;

@end
