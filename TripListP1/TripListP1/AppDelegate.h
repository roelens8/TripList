//
//  AppDelegate.h
//  TripListP1
//
//  Created by Armand Roelens on 3/24/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "StoreLocation.h"
#import "GroceryItem.h"
#import "TripList.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)NSString *PlacesAPIkey;
@property CLLocationManager *locationManager;
@property NSMutableArray *stores; //All Stores in the system
@property NSMutableArray *storeItems; //All Items that stores can sell

+ (AppDelegate*) instance;

//- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (NSString*)deviceLocation;
- (void)populateStores;
- (void)populateGroceryItems;
- (void)saveTripData;

@end

