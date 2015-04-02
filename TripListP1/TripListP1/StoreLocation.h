//
//  Location.h
//  TripListP1
//
//  Created by Jacob Parra on 3/28/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

@interface StoreLocation : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (readonly) NSString *name;
@property (readonly) NSString *openHours;
@property (readonly) NSNumber *priceLevel;
@property (readonly) NSString *address;

@end
