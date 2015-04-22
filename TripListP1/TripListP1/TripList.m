//
//  TripList.m
//  TripListP1
//
//  Created by Armand Roelens on 3/30/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "TripList.h"

@implementation TripList

static TripList *theTripList = nil;

- (id)init {
    self = [super init];
    if (self) {
        //Load from local storage
        /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TripList"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            self.trips = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSLog(@"%@", filePath);
        }*/
        //Load from Parse storage
        PFQuery *query = [PFQuery queryWithClassName:@"TripList"];
        [query whereKey:@"userName" equalTo:@"Test"];
        NSArray *tripsArray = [query findObjects];
        if ([tripsArray count] != 0) {
            PFObject *userTrip = [tripsArray firstObject];
            NSData *data = userTrip[@"Trips"];
            self.tripId = [userTrip objectId];
            self.trips = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            self.userName = userTrip[@"userName"];
            NSLog(@"%@", userTrip);
        }
    }
    return self;
}

+ (TripList*)sharedTripList {
    if (theTripList == nil) {
        theTripList = [[TripList alloc]init];
    }
    return theTripList;
}

@end
