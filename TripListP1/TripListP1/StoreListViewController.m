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
    
    //self.tripTotal.textColor = [UIColor colorWithRed:(229/255.0) green:(181/255.0) blue:(25/255.0) alpha:1];
    [self calculateTripTotal]; //Calculate new trip total before displaying table view
    [self.storeTableView reloadData]; //Cells were being duplicated
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.storeTableView reloadData]; //Cells were being duplicated
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
    TripList *tripList = [TripList sharedTripList];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"storeCell"];
        
        //If Stores exists then display them
        Trip *currentTrip = tripList.currentTrip;
        if (currentTrip.shoppingList != nil && [currentTrip.shoppingList count] > 0) {
            UILabel *storeTotalLabel = [[UILabel alloc] init];
            [storeTotalLabel setFrame:CGRectMake(300, 10, 80, 30)];
            storeTotalLabel.backgroundColor = [UIColor clearColor];
            storeTotalLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1];
            storeTotalLabel.adjustsFontSizeToFitWidth = YES;
            storeTotalLabel.tag = 1;
            [storeTotalLabel setFont:[UIFont boldSystemFontOfSize:20]];
            [cell.contentView addSubview:storeTotalLabel];
            
            cell.textLabel.text = [NSString stringWithFormat:@"  %@",[self.storeNames objectAtIndex:indexPath.row]];
            cell.restorationIdentifier = [NSString stringWithFormat:@"%@",[self.storeNames objectAtIndex:indexPath.row]];
        }
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        cell.textLabel.textColor = [UIColor colorWithRed:(205/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    }
    NSString *storeTotal = [self calculateStoreTotal:tripList storeIndex:indexPath.row];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"$ %@",storeTotal];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Navigate to Edit a Store View
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    tripList.currentStore = cell.restorationIdentifier;
    
    self.editStoreVC = [[EditStoreViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.editStoreVC = [storyboard instantiateViewControllerWithIdentifier:@"editStore"];
    [self.navigationController pushViewController:self.editStoreVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    Trip *trip = tripList.currentTrip;
    [trip.shoppingList removeObjectForKey:cell.restorationIdentifier];
    
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
            self.tripTotal.text = [NSString stringWithFormat:@"%.2f", [tripTotal floatValue]];
    }
}

- (NSString*)calculateStoreTotal:(TripList*)tripList storeIndex:(NSInteger)index {
    NSString *storeName = [self.storeNames objectAtIndex:index];
    NSMutableArray *itemsForStore = [tripList.currentTrip.shoppingList objectForKey:storeName];
    NSNumber *storeTotal = 0;
    if (itemsForStore != nil) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        for (GroceryItem *grocery in itemsForStore) {
            NSNumber *price = [formatter numberFromString:grocery.price];
            if (grocery.quantity == nil) {
                grocery.quantity = 0;
            }
            storeTotal = [NSNumber numberWithFloat:([storeTotal floatValue] + ([price floatValue] * [grocery.quantity floatValue]))];
        }
    }
    if (storeTotal == 0 || storeTotal == nil)
        return @"0.00";
    else
        return [NSString stringWithFormat:@"%.2f", [storeTotal floatValue]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
