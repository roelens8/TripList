//
//  EditStoreViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/29/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "EditStoreViewController.h"

@implementation EditStoreViewController

-(void)viewWillAppear:(BOOL)animated {
    
    self.filteredStoreItems = [NSMutableArray arrayWithCapacity:[self.storeItems count]];
    
    //Hide Search Bar until search button is clicked
    self.navigationController.navigationBar.hidden = NO;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    self.navigationItem.rightBarButtonItem = self.searchButton;
    [self.navigationItem.titleView setHidden:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    self.first = true;
    
    TripList *tripList = [TripList sharedTripList];
    Trip *currentTrip = tripList.currentTrip;
    self.currentStore.text = tripList.currentStore;
    
    AppDelegate *app = [AppDelegate instance];
    self.storeItems = [[NSMutableArray alloc]init];
    self.storeItems = app.storeItems;
    
    self.checkedItems = [[currentTrip.shoppingList objectForKey:tripList.currentStore] mutableCopy]; //Copy; Does not reference TripList singleton
    self.quantityFieldMap = [[NSMutableDictionary alloc]init];
    for (GroceryItem *checkedItem in self.checkedItems) {
        UITextField *quantityField = [[UITextField alloc]init];
        quantityField.text = checkedItem.quantity;
        [self.quantityFieldMap setObject:quantityField forKey:checkedItem.name];
    }
    [self calculateStoreTotal:tripList];
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredStoreItems count];
    } else {
        return [self.storeItems count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell"];
    UITextField *quantityField;
    //if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"editCell"];
        quantityField = [[UITextField alloc] initWithFrame:CGRectMake(310, 10, 30, 30)];
        quantityField.tag = 10;
        [cell addSubview:quantityField];
    //}
    
    //Create Quanity Field
    quantityField = (UITextField *)[cell viewWithTag:10];
    cell.subView = quantityField; //quantityField won't disappear after being selected and deselected
    quantityField.adjustsFontSizeToFitWidth = YES;
    quantityField.layer.cornerRadius = 5;
    quantityField.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    quantityField.textColor = [UIColor whiteColor];
    quantityField.textAlignment = NSTextAlignmentCenter;
    quantityField.keyboardType = UIKeyboardTypeDefault;
    quantityField.returnKeyType = UIReturnKeyDone;
    quantityField.clearButtonMode = UITextFieldViewModeNever;
    quantityField.text = @"0";
    [quantityField setEnabled: YES];
    
    //Set colors for search display table view
    self.tableView.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:153/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.searchDisplayController.searchResultsTableView.separatorColor = [UIColor whiteColor];
    self.searchDisplayController.searchResultsTableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    CGRect frame = self.searchDisplayController.searchResultsTableView.frame;
    frame.origin.x = -9;
    frame.size.width = 383;
    self.searchDisplayController.searchResultsTableView.frame = frame;
    cell.contentView.superview.backgroundColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1]; //Background color of accessory view and cell background
    [[UITableViewCell appearance] setTintColor:[UIColor colorWithRed:(0/255.0) green:(255/255.0) blue:(0/255.0) alpha:1]]; //Color of the checkmark
    
    GroceryItem *storeItem = [[GroceryItem alloc]init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if ([self.filteredStoreItems count] < 1) {
            ;
        }
        else {
            storeItem = [self.filteredStoreItems objectAtIndex:indexPath.row];
            for (int i = 0; i < [self.checkedItems count]; i++) {
                GroceryItem *checkedItem = self.checkedItems[i];
                if ([storeItem.name isEqualToString:checkedItem.name]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    NSLog(@"%@", checkedItem.quantity);
                    UITextField *groceryField = [self.quantityFieldMap objectForKey:checkedItem.name];
                    quantityField.text = groceryField.text;
                    break;
                }
                else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
    }
    else {
        storeItem = [self.storeItems objectAtIndex:indexPath.row];
        for (int i = 0; i < [self.checkedItems count]; i++) {
            GroceryItem *checkedItem = self.checkedItems[i];
            if ([storeItem.name isEqualToString:checkedItem.name]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                UITextField *groceryField = [self.quantityFieldMap objectForKey:checkedItem.name];
                quantityField.text = groceryField.text;
                break;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    /*if ([self.quantityFieldMap count] == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }*/
    //Display Store Items
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
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.2];
    cell.textLabel.textColor = [UIColor whiteColor] ;
    cell.detailTextLabel.textColor = [UIColor whiteColor] ;
    cell.contentView.backgroundColor = [UIColor colorWithRed:(205/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    
    return cell;
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
                [self.quantityFieldMap removeObjectForKey:checkedItem.name];
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
        [self.quantityFieldMap setObject:quantityField forKey:grocery.name];
        [self.checkedItems addObject:grocery];
    }
}

- (IBAction)editStore:(id)sender {
    TripList* tripList = [TripList sharedTripList];
    Trip *trip = [[Trip alloc]init];
    [self updateQuantityFields:self.tableView groceriesArray:self.storeItems]; //Update Quantity Fields if quantity was changed after the item was checked
    for (GroceryItem *groceryItem in self.checkedItems) {
        if (self.quantityFieldMap != nil){
            UITextField *field = [self.quantityFieldMap objectForKey:groceryItem.name];
            NSString *quanity = field.text;
            groceryItem.quantity = quanity;
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

- (void)calculateStoreTotal:(TripList*)tripList {
    NSMutableArray *itemsForStore = [tripList.currentTrip.shoppingList objectForKey:self.currentStore.text];
    NSNumber *storeTotal = 0;
    if (itemsForStore != nil) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        for (GroceryItem *grocery in itemsForStore) {
            NSNumber *price = [formatter numberFromString:grocery.price];
            if (grocery.quantity == nil) {
                grocery.quantity = @"0";
            }
            storeTotal = [NSNumber numberWithFloat:([storeTotal floatValue] + ([price floatValue] * [grocery.quantity floatValue]))];
        }
    }
    if (storeTotal == 0 || storeTotal == nil)
        self.storeTotal.text = @"0.00";
    else
        self.storeTotal.text = [NSString stringWithFormat:@"%.2f", [storeTotal floatValue]];
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    //Update the filtered array based on the search text
    [self.filteredStoreItems removeAllObjects]; //Clear all of the items from the filtered array
    //Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    self.filteredStoreItems = [NSMutableArray arrayWithArray:[self.storeItems filteredArrayUsingPredicate:predicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    //Makes the table data source reload when text changes
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
    [self updateQuantityFields:self.tableView groceriesArray:self.storeItems]; //If the user changed the quantity of a an item, and then clicked the search button, the previous changes in the self.tableView would disappear
    self.navigationItem.rightBarButtonItem = nil; //When search button is clicked, hide search button and animate showing the serach bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 0.5;
    fadeTextAnimation.type = kCATransitionFade;
    [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation forKey: @"fade"];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self.navigationItem.titleView setHidden:NO];
    [self.itemSearchBar setShowsCancelButton:YES animated:YES];
    
    [self.itemSearchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar {
    //When the search bar's "cancel" buton is clicked show, hide the search bar and show the search button
    self.navigationItem.rightBarButtonItem = self.searchButton;
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 0.5;
    fadeTextAnimation.type = kCAMediaTimingFunctionEaseOut;
    [self.navigationController.navigationBar.layer addAnimation:fadeTextAnimation forKey: @"easeOut"];
    [self.navigationItem.titleView setHidden:YES];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [aSearchBar setShowsCancelButton:NO animated:YES];
    
    [self updateQuantityFields:self.searchDisplayController.searchResultsTableView groceriesArray:self.filteredStoreItems];
    [self.tableView reloadData];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    for (UIButton *cancelButton in self.navigationController.navigationBar.subviews) {
        if ([cancelButton isKindOfClass:[UIButton class]]) {
            [cancelButton setTitle:@"Done" forState:UIControlStateNormal];
            break;
        }
    }
    for (UITextField *searchField in self.navigationController.navigationBar.subviews) {
        if ([searchField isKindOfClass:[UITextField class]]) {
            searchField.textColor = [UIColor colorWithRed:204/255.0 green:0/255.0 blue:0/255.0 alpha:1];
            searchField.backgroundColor = [UIColor whiteColor];
            /*searchField.attributedPlaceholder =
            [[NSAttributedString alloc]
             initWithString:@"Search Groceries"
             attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];*/
            break;
        }
    }
}

//If the quantity of a grocery item was changed after it was checked, update its quantity field with the new value
- (void)updateQuantityFields:(UITableView*)tableView groceriesArray:(NSMutableArray*)groceries {
    NSUInteger iter1 = 0;
    NSUInteger iterMax = [self.quantityFieldMap count];
    for (GroceryItem *item in groceries) {
        if (iter1 < iterMax) {
            //NSString *checkedGroceryName = [self.quantityFieldMap objectForKey:item.name];
            if ([self.quantityFieldMap objectForKey:item.name] != nil) {
                CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[groceries indexOfObject:item] inSection:0]];
                UITextField *currentQuantityField = (UITextField*)cell.subView;
                UITextField *checkedQuantityField = [self.quantityFieldMap objectForKey:item.name];
                //If CurrentQuantityField is nil but also checked, then the checked grocery item is not show in the searchdisplay table view. In order to prevent an error, set the currentQuantityField to the checkedQuantityField.
                if (currentQuantityField == nil) {
                    currentQuantityField = checkedQuantityField;
                }
                if (![currentQuantityField.text isEqualToString:checkedQuantityField.text]) {
                    [self.quantityFieldMap setObject:currentQuantityField forKey:item.name];
                }
                iter1++;
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
