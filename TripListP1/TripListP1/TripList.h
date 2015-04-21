//
//  TripList.h
//  TripListP1
//
//  Created by Armand Roelens on 3/30/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Trip.h"

@interface TripList : PFObject <PFSubclassing>

@property NSMutableArray *trips;
@property Trip *currentTrip; //For knowing which trip is currently selected
@property NSString *currentStore; //For knowing which store is currently selected
@property NSString *userName; //Username for retrieving TripList

+ (TripList*)sharedTripList;

@end
