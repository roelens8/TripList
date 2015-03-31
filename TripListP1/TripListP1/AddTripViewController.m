//
//  AddTripViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/26/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "AddTripViewController.h"
#import "Trip.h"
#import "TripList.h"

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTrip:(id)sender {
    UIAlertView *alert = [UIAlertView alloc];
    if ([self.tripNameField.text isEqual: @""]) {
        alert = [alert  initWithTitle:@"Invalid Trip Name"
                        message: @"Please enter a new trip name"
                        delegate:self
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK",nil];
        [alert show];
        return;
    }
    
    TripList* tripList = [TripList sharedTripList];
    Trip *trip = [[Trip alloc]init];
    trip.name = self.tripNameField.text;
    trip.date = self.tripDatePicker.date;
    trip.shoppingList = [[NSMutableDictionary alloc] init];
    if (tripList.trips == nil) { //This will only occcur if the file is empty
        tripList.trips = [[NSMutableArray alloc]init];
    }
    [tripList.trips addObject:trip];
    [self saveTripData];
    
    [self.navigationController popToViewController:(UIViewController*)self.tripListVC animated:YES];
    NSLog(@"%@ %@", self.tripNameField.text, self.tripDatePicker.date);
}

- (void)saveTripData {
    TripList *tripList = [TripList sharedTripList];
    if (tripList != nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"TripList"];
        [NSKeyedArchiver archiveRootObject:tripList.trips toFile:filePath];
    }
}

@end
