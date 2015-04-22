//
//  GroceryList.h
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CustomCell.h"

@interface GroceryItem : NSObject <NSCoding>

@property NSString *category;
@property NSString *name;
@property NSString *quantity;
@property NSString *price;
@property NSString *unit;

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end