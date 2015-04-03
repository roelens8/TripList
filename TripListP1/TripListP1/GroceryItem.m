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
        self.quantityField = nil;
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
        _category = [jsonDictionary objectForKey:@"category"];
        _name = [jsonDictionary objectForKey:@"name"];
        _quantity = [jsonDictionary objectForKey:@"quantity"];
        _price = [jsonDictionary objectForKey:@"price"];
        _unit = [jsonDictionary objectForKey:@"unit"];
        
    }
    return self;
}

@end