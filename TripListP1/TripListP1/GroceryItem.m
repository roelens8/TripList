//
//  GroceryList.m
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroceryItem.h"

@implementation GroceryItem

- (id)initWithCoder:(NSCoder *)deCoder {
    if ((self = [super init])) {
        // Decode the property values by key, and assign them to the correct ivars
        self.name = [deCoder decodeObjectForKey:@"name"];
        self.category = [deCoder decodeObjectForKey:@"category"];
        self.price = [deCoder decodeObjectForKey:@"price"];
        self.unit = [deCoder decodeObjectForKey:@"unit"];
        self.quantity = [deCoder decodeObjectForKey:@"quantity"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)enCoder {
    // Encode our ivars using string keys
    [enCoder encodeObject:self.name forKey:@"name"];
    [enCoder encodeObject:self.category forKey:@"category"];
    [enCoder encodeObject:self.price forKey:@"price"];
    [enCoder encodeObject:self.unit forKey:@"unit"];
    [enCoder encodeObject:self.quantity forKey:@"quantity"];
}

// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        
        // Assign all properties with keyed values from the dictionary
        self.category = [jsonDictionary objectForKey:@"category"];
        self.name = [jsonDictionary objectForKey:@"name"];
        self.quantity = [jsonDictionary objectForKey:@"quantity"];
        self.price = [jsonDictionary objectForKey:@"price"];
        self.unit = [jsonDictionary objectForKey:@"unit"];
        
    }
    return self;
}

@end