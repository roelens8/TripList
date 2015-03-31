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

-(id)init {
    self = [super init];
    if (self) {
        //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"books" ofType:@"plist"];
        //self.tripList = [NSMutableArray arrayWithContentsOfFile:filePath];
        
        //**Load TripList from file**
        self.trips = [[NSMutableArray alloc]init];
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
