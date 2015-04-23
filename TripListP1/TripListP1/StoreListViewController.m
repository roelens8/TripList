//
//  StoreListViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "StoreListViewController.h"

@interface StoreListViewController ()

@end

@implementation StoreListViewController

- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
    
    TripList *tripList = [TripList sharedTripList];
    self.storeNames = [tripList.currentTrip.shoppingList allKeys]; //Array for displaying stores of a trip
    
    [self calculateTripTotal]; //Calculate new trip total before displaying table view
    [self.storeTableView reloadData]; //Some cells were being duplicated
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TripList *tripList = [TripList sharedTripList];
    Trip *currentTrip = tripList.currentTrip;
    return [currentTrip.shoppingList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:@"storeCell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"storeCell"];
    }
    //If Stores exist then display them
    TripList *tripList = [TripList sharedTripList];
    Trip *currentTrip = tripList.currentTrip;
    
    if (currentTrip.shoppingList != nil && [currentTrip.shoppingList count] > 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.storeNames objectAtIndex:indexPath.row]];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Navigate to Edit a Store View
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    tripList.currentStore = cell.textLabel.text;
    
    self.editStoreVC = [[EditStoreViewController  alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.editStoreVC = [storyboard instantiateViewControllerWithIdentifier:@"editStore"];
    [self.navigationController pushViewController:self.editStoreVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    Trip *trip = tripList.currentTrip;
    [trip.shoppingList removeObjectForKey:cell.textLabel.text];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self calculateTripTotal];
    AppDelegate *app = [AppDelegate instance];
    [app saveTripData];
}

- (void)calculateTripTotal {
    TripList *tripList = [TripList sharedTripList];
    self.groceryItems = [tripList.currentTrip.shoppingList allValues]; //Array of groceries to calculate the Trip Total
    if (self.groceryItems != nil) {
        NSNumber *tripTotal = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        for (NSMutableArray *groceryList in self.groceryItems) {
            for (GroceryItem *grocery in groceryList) {
                NSNumber *price = [formatter numberFromString:grocery.price];
                if (grocery.quantity == nil) {
                    grocery.quantity = 0;
                }
                tripTotal = [NSNumber numberWithFloat:([tripTotal floatValue] + ([price floatValue] * [grocery.quantity floatValue]))];
            }
        }
        if (tripTotal == 0 || tripTotal == nil)
            self.tripTotal.text = @"0.00";
        else
            self.tripTotal.text = [tripTotal stringValue];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
