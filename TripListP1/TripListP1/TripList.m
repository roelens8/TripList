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
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TripList"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            self.trips = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            //NSLog(@"%@", filePath);
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
