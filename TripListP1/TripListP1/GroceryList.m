//
//  GroceryList.m
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GroceryList.h"

@implementation GroceryList

// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        
        // Assign all properties with keyed values from the dictionary
        _category = [jsonDictionary objectForKey:@"category"];
        _name = [jsonDictionary objectForKey:@"name"];
        _quantity = [jsonDictionary objectForKey:@"quantity"];
        
    }
    return self;
}

@end