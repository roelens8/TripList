//
//  EditStoreViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "EditStoreViewController.h"

@interface EditStoreViewController ()

@end

@implementation EditStoreViewController

-(void)viewWillAppear:(BOOL)animated {
    TripList *tripList = [TripList sharedTripList];
    Trip *currentTrip = tripList.currentTrip;
    self.currentStore.text = tripList.currentStore;
    
    AppDelegate *app = [AppDelegate instance];
    self.storeItems = [[NSMutableArray alloc]init];
    self.storeItems = app.storeItems;
    
    self.checkedItems = [[NSMutableArray alloc]init];
    self.checkedItems = [[currentTrip.shoppingList objectForKey:tripList.currentStore] mutableCopy]; //Copy; Does not reference TripList singleton
    self.filteredStoreItems = [NSMutableArray arrayWithCapacity:[self.storeItems count]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Determine whether the normal table or the search results table is being displayed and based on that return the appropriate count
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredStoreItems count];
    } else {
        return [self.storeItems count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"editCell"];
    }
    
    //Create Quantity Field
    UITextField *quantityField = [[UITextField alloc] initWithFrame:CGRectMake(310, 10, 30, 30)];
    cell.subView = quantityField; //quantityField won't disappear after being selected and deselected
    quantityField.adjustsFontSizeToFitWidth = YES;
    quantityField.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    quantityField.textColor = [UIColor blackColor];
    quantityField.textAlignment = NSTextAlignmentCenter;
    quantityField.keyboardType = UIKeyboardTypeDefault;
    quantityField.returnKeyType = UIReturnKeyDone;
    quantityField.clearButtonMode = UITextFieldViewModeNever;
    [quantityField setEnabled: YES];
    
    //Display Store Items
    //Check to see whether the normal table or the search results table is being displayed from the proper array
    GroceryItem *storeItem;
    if (tableView == self.searchDisplayController.searchResultsTableView){
        storeItem = [self.filteredStoreItems objectAtIndex:indexPath.row];
    } else {
        storeItem = [self.storeItems objectAtIndex:indexPath.row];
    }
    NSString *itemDescription = [NSString stringWithFormat:@" \u200b%@\u200b - %@", storeItem.name, storeItem.category];
    if (storeItem.price != nil) {
        NSString *price = [NSString stringWithFormat:@" Price: %@", storeItem.price];
        NSString *unit = [NSString stringWithFormat:@"%@", storeItem.unit];
        NSString * strRR = [NSString stringWithFormat:@"%@ - %@", price, unit];
        cell.detailTextLabel.text = strRR;
    }
    else {
        cell.detailTextLabel.text = @"\tPrice: N/A";
    }
    cell.textLabel.text = itemDescription;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.2];
    
    for (int i = 0; i < [self.checkedItems count]; i++) {
        GroceryItem *checkedItem = self.checkedItems[i];
        if ([storeItem.name isEqualToString:checkedItem.name]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            checkedItem.quantityField = quantityField;
            quantityField.text = checkedItem.quantity;
            break;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            quantityField.text = @"0";
        }
    }
    [cell addSubview:quantityField];
    return cell;
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text
    // Clear all of the items from the filtered array
    [self.filteredStoreItems removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    _filteredStoreItems = [NSMutableArray arrayWithArray:[_storeItems filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Makes the table data source reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSArray *splitArrayName = [cell.textLabel.text componentsSeparatedByString: @"\u200b"];
    NSString *checkedGroceryName = [splitArrayName objectAtIndex: 1];
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        for (GroceryItem *checkedItem in self.checkedItems) {
            if ([checkedItem.name isEqualToString:checkedGroceryName]) {
                [self.checkedItems removeObject:checkedItem];
                break;
            }
        }
    }
    else if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        NSArray *splitArrayCategory = [cell.textLabel.text componentsSeparatedByString: @" "];
        NSArray *splitArrayPriceUnit = [cell.detailTextLabel.text componentsSeparatedByString: @" "];
        NSString *checkedGroceryCategory = [splitArrayCategory objectAtIndex:3];
        NSString *checkedGroceryPrice = [splitArrayPriceUnit objectAtIndex:2];
        NSString *checkedGroceryUnit = [splitArrayPriceUnit objectAtIndex:4];
        UITextField *quantityField = (UITextField*)cell.subView;
        GroceryItem *grocery = [[GroceryItem alloc]init];
        grocery.name = checkedGroceryName;
        grocery.category = checkedGroceryCategory;
        grocery.price = checkedGroceryPrice;
        grocery.unit = checkedGroceryUnit;
        grocery.quantity = quantityField.text;
        grocery.quantityField = quantityField;
        [self.checkedItems addObject:grocery];
    }
}

- (IBAction)editStore:(id)sender {
    TripList* tripList = [TripList sharedTripList];
    Trip *trip = [[Trip alloc]init];
    
    for (GroceryItem *groceryItem in self.checkedItems) {
        if (groceryItem.quantityField != nil){
            groceryItem.quantity = groceryItem.quantityField.text;
            groceryItem.quantityField = nil;
        }
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        BOOL isInteger = [formatter numberFromString:groceryItem.quantity] != nil;
        if (!isInteger) {
            groceryItem.quantity = @"0";
        }
    }
    for (int i = 0; i < [tripList.trips count]; i++) {
        if (tripList.currentTrip == tripList.trips[i]) {
            trip = tripList.trips[i];
            [trip.shoppingList setObject:self.checkedItems forKey:self.currentStore.text];
            tripList.currentTrip = trip;
            tripList.trips[i] = trip;
            break;
        }
    }
    AppDelegate *app = [AppDelegate instance];
    [app saveTripData];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(IBAction)goToSearch:(id)sender {
    [self.itemSearchBar becomeFirstResponder];
}

@end
