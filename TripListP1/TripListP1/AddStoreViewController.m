//
//  AddStoreViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "AddStoreViewController.h"

@interface AddStoreViewController ()

@end

@implementation AddStoreViewController

- (void)viewWillAppear:(BOOL)animated {
   
    self.navigationController.navigationBar.hidden = NO;
    self.itemSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    [self.itemSearchBar setBarTintColor:[UIColor blackColor]];
    
    self.filteredStoreItems = [NSMutableArray arrayWithCapacity:[self.storeItems count]];
    
    //self.navigationItem.titleView = self.itemSearchBar;
    
    self.stores = [[NSMutableArray alloc]init];
    self.storeItems = [[NSMutableArray alloc]init];
    self.storeNames = [[NSMutableArray alloc]init];
    self.storePickerSelectedStore = [[NSString alloc]init];
    
    self.checkedGName = [[NSMutableArray alloc]init];
    self.checkedGField = [[NSMutableArray alloc]init];
    self.first = true;
    
    AppDelegate *app = [AppDelegate instance];
    self.stores = app.stores;
    self.storeItems = app.storeItems;
    
    //Removes duplicate store names - puts the non-duplicate store names into an array for display in the pickerView
    NSMutableArray *tempStoreNameList = [[NSMutableArray alloc]init];
    for (StoreLocation *store in self.stores) {
        [tempStoreNameList addObject:store.name];
    }
    [self.storeNames addObjectsFromArray:[[NSSet setWithArray:tempStoreNameList] allObjects]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.storeNames count];
}

/*//Not needed because of viewForRow methods
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *storeName = [self.storeNames objectAtIndex:row];
    return storeName;
}*/

//Editing the pickerView
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* textView = (UILabel*)view;
    if (!textView){
        textView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 275, 60)];
        textView.adjustsFontSizeToFitWidth = YES;
        [textView setBackgroundColor:[UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1]];
        [textView setFont:[UIFont boldSystemFontOfSize:20]];
        [textView setText:[self.storeNames objectAtIndex:row]];
        [textView setTextAlignment:NSTextAlignmentCenter];
        [textView setTextColor:[UIColor whiteColor]];
        [textView setOpaque:false];
    }
    return textView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.storePickerSelectedStore = [self.storeNames objectAtIndex:[self.storePicker selectedRowInComponent:0]];
    self.storePickerSelectedRow = [self.storePicker selectedRowInComponent:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredStoreItems count];
    } else {
        return [self.storeItems count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell;// = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    //if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"foodCell"];
    //}
    
    //Create Quanity Field
    UITextField *quantityField = [[UITextField alloc] initWithFrame:CGRectMake(310, 10, 30, 30)];
    cell.subView = quantityField; //quantityField won't disappear after being selected and deselected
    quantityField.adjustsFontSizeToFitWidth = YES;
    quantityField.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    quantityField.textColor = [UIColor whiteColor];
    quantityField.textAlignment = NSTextAlignmentCenter;
    quantityField.keyboardType = UIKeyboardTypeDefault;
    quantityField.returnKeyType = UIReturnKeyDone;
    quantityField.clearButtonMode = UITextFieldViewModeNever;
    quantityField.text = @"0";
    [quantityField setEnabled: YES];
    [cell addSubview:quantityField];
    
    self.addStoreTableView.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [[UITableViewCell appearance] setTintColor:[UIColor colorWithRed:(0/255.0) green:(200/255.0) blue:(0/255.0) alpha:1]];
    
    //Display Store Items
    //Check to see whether the normal table or the search results table is being displayed from the proper array
    GroceryItem *storeItem = [[GroceryItem alloc]init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        storeItem = [self.filteredStoreItems objectAtIndex:indexPath.row];
        for (NSString *checkedGrocery in self.checkedGName) {
            NSArray *splitCheckedGrocery = [checkedGrocery componentsSeparatedByString: @"\u200b"];
            NSString *checkedGroceryName = [splitCheckedGrocery objectAtIndex: 0];
            if ([storeItem.name isEqual:checkedGroceryName]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                UITextField *groceryField = [self.checkedGField objectAtIndex:[self.checkedGName indexOfObject:checkedGrocery]];
                quantityField.text = groceryField.text;
                break;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    else {
        storeItem = [self.storeItems objectAtIndex:indexPath.row];
        for (NSString *checkedGrocery in self.checkedGName) {
            NSArray *splitCheckedGrocery = [checkedGrocery componentsSeparatedByString: @"\u200b"];
            NSString *checkedGroceryName = [splitCheckedGrocery objectAtIndex: 0];
            if ([storeItem.name isEqual:checkedGroceryName]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                UITextField *groceryField = [self.checkedGField objectAtIndex:[self.checkedGName indexOfObject:checkedGrocery]];
                quantityField.text = groceryField.text;
                break;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    if ([self.checkedGName count] == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *itemDescription = [NSString stringWithFormat:@" \u200b%@\u200b - \u200b%@", storeItem.name, storeItem.category];
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
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.2];
    cell.textLabel.textColor = [UIColor whiteColor] ;
    cell.detailTextLabel.textColor = [UIColor whiteColor] ;
    cell.contentView.backgroundColor = [UIColor colorWithRed:(205/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];

    //Checked gorceries names and quantities will be put into an array
    NSArray *splitArrayName = [cell.textLabel.text componentsSeparatedByString: @"\u200b"];
    NSArray *splitArrayCategory = [cell.textLabel.text componentsSeparatedByString: @"\u200b"];
    NSArray *splitArrayPriceUnit = [cell.detailTextLabel.text componentsSeparatedByString: @" "];
    NSString *checkedGroceryName = [splitArrayName objectAtIndex: 1];
    NSString *checkedGroceryCategory = [splitArrayCategory objectAtIndex:3];
    NSString *checkedGroceryPrice = [splitArrayPriceUnit objectAtIndex:2];
    NSString *checkedGroceryUnit = [splitArrayPriceUnit objectAtIndex:4];
    UITextField *quantityField = (UITextField*)cell.subView;
    CheckedGroceryItem *checkedItem = [[CheckedGroceryItem alloc]init];
    checkedItem.groceryItemString = [NSString stringWithFormat:@"%@\u200b%@\u200b%@\u200b%@",checkedGroceryName, checkedGroceryCategory, checkedGroceryPrice, checkedGroceryUnit];
    checkedItem.quantityField = quantityField;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) { //SearchDisplayTableView
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            NSUInteger index = [self.checkedGName indexOfObject:checkedItem.groceryItemString];
            [self.checkedGName removeObject:checkedItem.groceryItemString];
            [self.checkedGField removeObjectAtIndex:index];
        }
        else if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            [self.checkedGName addObject:checkedItem.groceryItemString];
            [self.checkedGField addObject:checkedItem.quantityField];
        }
    }
    else // AddStoreTableView
    {
        if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
                NSUInteger index = [self.checkedGName indexOfObject:checkedItem.groceryItemString];
            [self.checkedGName removeObject:checkedItem.groceryItemString];
            [self.checkedGField removeObjectAtIndex:index];

        }
        else if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            [self.checkedGName addObject:checkedItem.groceryItemString];
            [self.checkedGField addObject:checkedItem.quantityField];
        }
    }
}

- (void)addStore:(id)sender {
    //Create a store and add it to the sharedTripList then save it
    TripList* tripList = [TripList sharedTripList];
    Trip *trip = [[Trip alloc]init];
    NSMutableArray *groceries = [[NSMutableArray alloc]init];
    for (int i = 0; i < [tripList.trips count]; i++) {
        if (tripList.currentTrip == tripList.trips[i]) {
            trip = tripList.trips[i];
            for (NSString* checkedGrocery in self.checkedGName) {
                NSArray *splitGrocery = [checkedGrocery componentsSeparatedByString: @"\u200b"];
                NSString *groceryName = [splitGrocery objectAtIndex: 0];
                NSString *groceryCategory = [splitGrocery objectAtIndex: 1];
                NSString *groceryPrice = [splitGrocery objectAtIndex:2];
                UITextField *groceryField = [self.checkedGField objectAtIndex:[self.checkedGName indexOfObject:checkedGrocery]];
                NSString *groceryQuantity = groceryField.text;
                
                NSString *groceryUnit = [splitGrocery objectAtIndex:3];
                if ([groceryPrice isEqualToString:@"N/A"] || [groceryPrice isEqualToString:@""])
                    groceryPrice = @"0";
                
                GroceryItem *grocery = [[GroceryItem alloc]init];
                grocery.name = groceryName;
                grocery.category = groceryCategory;
                grocery.price = groceryPrice;
                grocery.unit = groceryUnit;
                grocery.quantity = groceryQuantity;
                [groceries addObject:grocery]; //Add grocery to grocery list
            }
            
            //If Store is already in the store list, then alert
            if (self.storePickerSelectedRow == 0) {
                self.storePickerSelectedStore = [self.storeNames objectAtIndex:0]; 
            }
            for (NSString *storeTemp in [trip.shoppingList allKeys]) {
                if ([self.storePickerSelectedStore isEqualToString:storeTemp]) {
                    UIAlertView *alert = [UIAlertView alloc];
                    alert = [alert  initWithTitle:@"Store Already Exists"
                                    message: @"Please select another store!"
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"OK",nil];
                    [alert show];
                    return;
                }
            }
            for (GroceryItem *groceryItem in groceries) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                BOOL isInteger = [formatter numberFromString:groceryItem.quantity] != nil;
                if (!isInteger) {
                    groceryItem.quantity = @"0";
                }
            }
            [trip.shoppingList setObject:groceries forKey:self.storePickerSelectedStore];
            tripList.currentTrip = trip;
            break;
        }
    }
    AppDelegate *app = [AppDelegate instance];
    [app saveTripData];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text
    // Clear all of the items from the filtered array
    [self.filteredStoreItems removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    self.filteredStoreItems = [NSMutableArray arrayWithArray:[self.storeItems filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Makes the table data source reload when text changes
    //There was a bug when setting quantity fields to 0, but this fixed that problem
    if (self.first)
        self.first = false;
    else
        [self updateQuantityFields:self.searchDisplayController.searchResultsTableView groceriesArray:self.filteredStoreItems];
    
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (IBAction)goToSearch:(id)sender {
    [self.itemSearchBar becomeFirstResponder];
    [self updateQuantityFields:self.addStoreTableView groceriesArray:self.storeItems];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {
    self.first = true;
    [self updateQuantityFields:self.searchDisplayController.searchResultsTableView groceriesArray:self.filteredStoreItems];
    [self.addStoreTableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

//If the quantity of a grocery item was changed after it was checked, update its quantity field with the new value
- (void)updateQuantityFields:(UITableView*)tableView groceriesArray:(NSMutableArray*)groceries {
    NSUInteger iter1 = 0;
    NSUInteger iterMax = [self.checkedGName count];
    for (GroceryItem *item in groceries) {
        if (iter1 < iterMax) {
            for (NSUInteger count = 0; count < [self.checkedGName count]; count++) {
                NSString *checkedGrocery = [self.checkedGName objectAtIndex:count];
                NSArray *splitCheckedGrocery = [checkedGrocery componentsSeparatedByString: @"\u200b"];
                NSString *checkedGroceryName = [splitCheckedGrocery objectAtIndex: 0];
            
                if ([item.name isEqualToString:checkedGroceryName]) {
                    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[groceries indexOfObject:item] inSection:0]];
                
                    UITextField *currentQuantityField = (UITextField*)cell.subView;
                    UITextField *checkedQuantityField = [self.checkedGField objectAtIndex:count];
                    if (![currentQuantityField.text isEqualToString:checkedQuantityField.text]) {
                        [self.checkedGField replaceObjectAtIndex:count withObject:currentQuantityField];
                    }
                    iter1++;
                    break;
                }
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
