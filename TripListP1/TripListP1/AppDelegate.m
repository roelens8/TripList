//
//  AppDelegate.m
//  TripListP1
//
//  Created by Armand Roelens on 3/24/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.m
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    //Enable Parse Local Datastore
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"parseAppId" clientKey:@"parseClientKey"];
    //Initialize Parse
    [Parse setApplicationId:@"jds76phixswhTcwBr3ms0lh6PBdklp85dnqkrOkx"
                  clientKey:@"MP2arnY3WRUEn11hUEgBwaAq71KW7hFCOMksTZkh"];
    
    //Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    _PlacesAPIkey = @"AIzaSyDxw5AZ3wflWT5YDNuHJNVdPSi9Lm7hV9M";
    // Async mutithreaded method call to retreive google nearby places while the user does other things.
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(globalConcurrentQueue, ^{
        [self populateStores];
        [self populateGroceryItems];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
        });
    });
    
    self.stores = [[NSMutableArray alloc]init];
    self.storeItems = [[NSMutableArray alloc]init];

    // Getting lat and log in simulator does not work need to find fix.
    //self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    //self.locationManager.delegate = self;
    //[self.locationManager requestAlwaysAuthorization];
    //[self.locationManager startUpdatingLocation];
    //NSLog(@"%@", [self deviceLocation]);
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (AppDelegate *)instance {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

//Saves Data to both Parse and local storage
- (void)saveTripData {
    TripList *tripList = [TripList sharedTripList];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tripList.trips];
    
    //If it's the first time trips are saved (Insert)
    if (tripList.tripId == nil) {
        PFObject *test = [PFObject objectWithClassName:@"TripList"];
        test[@"Trips"] = data;
        tripList.userName = @"Test"; //Remove when login is implemented
        test[@"userName"] = tripList.userName;
        [test saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                tripList.tripId = [test objectId];
                NSLog(@"%@", @"Successly saved to Parse");
            } else {
                NSLog(@"%@", error.description);
            }
        }];
    }
    else {
        //If trips already exist (Update)
        PFQuery *query = [PFQuery queryWithClassName:@"TripList"];
        [query getObjectInBackgroundWithId:tripList.tripId block:^(PFObject *userTrip, NSError *error) {
            userTrip[@"Trips"] = data;
            [userTrip saveInBackground];
            if (!error)
                NSLog(@"%@", @"Successly saved to Parse!");
            else
                NSLog(@"%@", error.description);
        }];
    }
    if (tripList != nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TripList"];
        [NSKeyedArchiver archiveRootObject:tripList.trips toFile:filePath];
    }
}

//Jacob P
- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"%f %f", newLocation.coordinate.longitude, oldLocation.coordinate.latitude);

}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%ld", (long)[error code]);
}

//Jacob P
- (void)populateStores {
    //request stuff
    //NSString *latlong = [NSString stringWithFormat: @"%@", self.deviceLocation];
    //NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@&radius=500&types=grocery_or_supermarket&key=%@", latlong, _PlacesAPIkey];
    
    NSString *urlString = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.4106930,-111.9257050&radius=5000&types=grocery_or_supermarket&key=AIzaSyAqs6W4O0sywZkROfKvEZ3GlK8bFIpyayI";
    NSURL *requestURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:(requestURL)];
    
    //response
    //NSData *storeData =[NSData dataWithContentsOfURL:requestURL];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSError *jsonParsingError = nil;
    NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    
    // Create a new array to hold the locations
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [locationResults objectForKey:@"results"];
    
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        StoreLocation *location = [[StoreLocation alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [locations addObject:location];
    }
    
    NSMutableArray *storeList = [[NSMutableArray alloc]init];
    for (StoreLocation *store in locations) {
        NSLog(@"Name: %@ ", store.name);
        NSLog(@"Open: %@ ", store.openHours);
        NSLog(@"Price Level: %@ ", store.priceLevel);
        NSLog(@"Address: %@ ", store.address);
        [storeList addObject:store];
    }
    [self.stores addObjectsFromArray:[[NSSet setWithArray:storeList] allObjects]];
}

//Jacob P
- (void)populateGroceryItems {
    NSString *urlString = [NSString stringWithFormat:@"https://api.myjson.com/bins/2m0ep"];
    NSURL *requestURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:(requestURL)];
    
    //response
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    // Create a new array to hold the locations
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [locationResults objectForKey:@"groceryCategories"];
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        GroceryItem *grocery = [[GroceryItem alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [locations addObject:grocery];
    }
    
    for (GroceryItem *item in locations) {
//        NSLog(@"Category: %@ ", item.category);
//        NSLog(@"Name: %@ ", item.name);
//        NSLog(@"Quantity: %@ ", item.quantity);
//        NSLog(@"Price: %@ ", item.price);
//        NSLog(@"Unit: %@ ", item.unit);
       [self.storeItems addObject:item];
    }
}

@end
