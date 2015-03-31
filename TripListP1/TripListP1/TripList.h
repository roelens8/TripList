//
//  TripList.h
//  TripListP1
//
//  Created by Armand Roelens on 3/30/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripList : NSObject

@property NSMutableArray *trips;

+ (TripList*)sharedTripList;

@end
