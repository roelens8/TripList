//
//  TripListViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/24/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "TripListViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Location.h"
#import "GroceryList.h"
#import "AppDelegate.h"

@interface TripListViewController ()

@property (nonatomic)NSString *PlacesAPIkey;

@end

@implementation TripListViewController

CLLocationManager *locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _PlacesAPIkey = [NSString stringWithFormat: @"AIzaSyDxw5AZ3wflWT5YDNuHJNVdPSi9Lm7hV9M"];
    
// Getting lat and log in simulator does not work need to find fix.
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
//    [locationManager startUpdatingLocation];
//    NSLog(@"%@", [self deviceLocation]);

    
    // Async mutithreaded method call to retreive google nearby places while the user does other things.
    dispatch_queue_t globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(globalConcurrentQueue, ^{
        [self getGroceriesPlaces];
        [self getGroceryItems];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
        });
    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"tripCell"];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}

//Jacob P

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

//Jacob P
- (void)getGroceriesPlaces
{
    //request stuff
    //NSString *latlong = [NSString stringWithFormat: @"%@", self.deviceLocation];
    //NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@&radius=500&types=grocery_or_supermarket&key=%@", latlong, _PlacesAPIkey];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=33.468239,-112.2562734&radius=5000&types=grocery_or_supermarket&key=%@", _PlacesAPIkey];
    
    NSURL *requestURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:(requestURL)];
    
    //response
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
    
    // Create a new array to hold the locations
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [locationResults objectForKey:@"results"];
    
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        Location *location = [[Location alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [locations addObject:location];
    }
    
    for (Location *test in locations) {
        NSLog(@"Name: %@ ", test.name);
        NSLog(@"Open: %@ ", test.openHours);
        NSLog(@"Price Level: %@ ", test.priceLevel);
        NSLog(@"Address: %@ ", test.address);
    }
   }

//Jacob P
- (void)getGroceryItems
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.myjson.com/bins/2h207"];
    
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
         GroceryList *grocery = [[GroceryList alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [locations addObject:grocery];
    }
    
    for (GroceryList *test in locations) {
        NSLog(@"Category: %@ ", test.category);
        NSLog(@"Name: %@ ", test.name);
        NSLog(@"Quantity: %@ ", test.quantity);
    }
}

@end
