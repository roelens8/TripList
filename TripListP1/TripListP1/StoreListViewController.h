//
//  StoreListViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStoreViewController.h"
#import "EditStoreViewController.h"
#import "TripList.h"
#import "Trip.h"
#import "GroceryItem.h"

@interface StoreListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property AddStoreViewController *addStoreVC;
@property EditStoreViewController *editStoreVC;
@property Trip *currentTrip;
@property NSArray *storeNames;
@property NSArray *groceryItems;
@property (strong, nonatomic) IBOutlet UILabel *tripTotal;
@property (strong, nonatomic) IBOutlet UITableView *storeTableView;

@end
