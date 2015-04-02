//
//  TripListViewController.h
//  TripListP1
//
//  Created by Armand Roelens on 3/24/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTripViewController.h"
#import "StoreListViewController.h"
#import "TripList.h"
#import "Trip.h"

@interface TripListViewController : UIViewController <UITableViewDelegate, UITableViewDelegate>

//@property TripList *tripList;
@property AddTripViewController *addTripVC;
@property StoreListViewController *storeListVC;

@end

