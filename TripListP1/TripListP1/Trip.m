//
//  Trip.m
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "Trip.h"

@implementation Trip

- (id)initWithCoder:(NSCoder *)deCoder {
    if ((self = [super init])) {
        // Decode the property values by key, and assign them to the correct ivars
        self.name = [deCoder decodeObjectForKey:@"name"];
        self.date = [deCoder decodeObjectForKey:@"date"];
        self.shoppingList = [deCoder decodeObjectForKey:@"shoppingList"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)enCoder {
    // Encode our ivars using string keys
    [enCoder encodeObject:self.name forKey:@"name"];
    [enCoder encodeObject:self.date forKey:@"date"];
    [enCoder encodeObject:self.shoppingList forKey:@"shoppingList"];
}

@end
