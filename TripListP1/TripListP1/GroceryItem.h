//
//  GroceryList.h
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

@interface GroceryItem : NSObject

@property (readonly) NSString *category;
@property (readonly) NSString *name;
@property (readonly) NSNumber *quantity; //Irrelevant for the Store Object
@property (readonly) NSNumber *price;

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end