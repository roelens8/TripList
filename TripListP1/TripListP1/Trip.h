//
//  Trip.h
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject <NSCoding>

@property NSString *name;
@property NSDate *date;
@property NSMutableDictionary *shoppingList; //Key: Store Name, Value: NSMutableArray of GroceryItems (This array contains the shopping list of the groceries per store

@end
