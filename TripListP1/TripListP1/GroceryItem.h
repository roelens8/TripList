//
//  GroceryList.h
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CustomCell.h"

@interface GroceryItem : PFObject <NSCoding, PFSubclassing>

@property NSString *category;
@property NSString *name;
@property NSString *quantity; //Irrelevant for the Store Object
@property NSString *price;
@property NSString *unit;

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end