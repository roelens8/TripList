//
//  Location.m
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Location.h"

@implementation Location

// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _name = [jsonDictionary objectForKey:@"name"];
        _openHours = [jsonDictionary objectForKey:@"opening_hours"];
        
        _priceLevel = [jsonDictionary objectForKey:@"price_level"];
        _address = [jsonDictionary objectForKey:@"vicinity"];

    }
    return self;
}

@end