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
                tripTotal = [NSNumber numberWithInteger:([tripTotal doubleValue] + ([price doubleValue] * [grocery.quantity integerValue]))];
            }
        }
        self.tripTotal.text = [tripTotal stringValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return [self.storeNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"storeCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"storeCell"];
    }
    //If Stores exist then display them
    if (self.storeNames != nil && [self.storeNames count] > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"\t\t\t\t\t%@",self.storeNames[indexPath.row]];
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //Navigate to Edit a Store View
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if ([segue.identifier isEqualToString:@"addStore"]) {
        //self.addTripVC = (AddTripViewController *)segue.destinationViewController;
        //self.addTripVC.tripListVC = self;
    //}
}


@end
