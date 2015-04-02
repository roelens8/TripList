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
    TripList *tripList = [TripList sharedTripList];
    self.storeNames = [tripList.currentTrip.shoppingList allKeys]; //Array for displaying stores of a trip
    
    self.groceryItems = [tripList.currentTrip.shoppingList allValues]; //Array of groceries to calculate the Trip Total
    if ((self.groceryItems != nil) && ([self.groceryItems count] > 0)) {
        NSNumber *tripTotal = 0;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        for (NSMutableArray *groceryList in self.groceryItems) {
            for (GroceryItem *grocery in groceryList) {
                NSNumber *price = [formatter numberFromString:grocery.price];
                if (grocery.quantity == nil) {
                    grocery.quantity = 0;
                }
                tripTotal = [NSNumber numberWithInteger:([tripTotal doubleValue] + ([price doubleValue] * [grocery.quantity doubleValue]))];
            }
        }
        if (tripTotal == nil)
            self.tripTotal.text = @"0";
        else
            self.tripTotal.text = [tripTotal stringValue];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"storeCell"];
    }
    //If Stores exist then display them
    TripList *tripList = [TripList sharedTripList];
    Trip *currentTrip = tripList.currentTrip;
    
    if (currentTrip.shoppingList != nil && [currentTrip.shoppingList count] > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.storeNames objectAtIndex:indexPath.row]];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    //Navigate to Edit a Store View
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    tripList.currentStore = cell.textLabel.text;
    //Trip *trip = [tripList.trips objectAtIndex:indexPath.row];
    
    
    self.editStoreVC = [[EditStoreViewController  alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.editStoreVC = [storyboard instantiateViewControllerWithIdentifier:@"editStore"];
    [self.navigationController pushViewController:self.editStoreVC animated:YES];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if ([segue.identifier isEqualToString:@"addStore"]) {
        //self.addTripVC = (AddTripViewController *)segue.destinationViewController;
        //self.addTripVC.tripListVC = self;
    //}
}


@end
