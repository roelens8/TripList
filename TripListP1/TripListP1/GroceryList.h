//
//  GroceryList.h
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#ifndef TripListP1_GroceryList_h
#define TripListP1_GroceryList_h


#endif

@interface GroceryList : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
@property (readonly) NSString *category;
@property (readonly) NSString *name;
@property (readonly) NSNumber *quantity;



@end