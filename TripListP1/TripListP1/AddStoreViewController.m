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
    
    self.navigationItem.titleView = self.itemSearchBar;
    
    self.stores = [[NSMutableArray alloc]init];
    self.storeItems = [[NSMutableArray alloc]init];
    self.storeNames = [[NSMutableArray alloc]init];
    self.checkedGroceries = [[NSMutableArray alloc]init];
    self.checkedCellRows = [[NSMutableArray alloc]init];
    self.storePickerSelectedStore = [[NSString alloc]init];
    
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
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setFont:[UIFont boldSystemFontOfSize:20]];
        [textView setText:[self.storeNames objectAtIndex:row]];
        [textView setTextAlignment:NSTextAlignmentCenter];
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
    return [self.storeItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"foodCell"];
    }
    
    //Create Quanity Field
    UITextField *quantityField = [[UITextField alloc] initWithFrame:CGRectMake(310, 10, 30, 30)];
    cell.subView = quantityField; //quantityField won't disappear after being selected and deselected
    quantityField.adjustsFontSizeToFitWidth = YES;
    quantityField.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    quantityField.textColor = [UIColor blackColor];
    quantityField.textAlignment = NSTextAlignmentCenter;
    quantityField.keyboardType = UIKeyboardTypeDefault;
    quantityField.returnKeyType = UIReturnKeyDone;
    quantityField.clearButtonMode = UITextFieldViewModeNever;
    quantityField.text = @"0";
    [quantityField setEnabled: YES];
    [cell addSubview:quantityField];
    
    //Display Store Items
    GroceryItem *storeItem = [self.storeItems objectAtIndex:indexPath.row];
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
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:(205/255.0) green:(0/255.0) blue:(0/255.0) alpha:1] ;
    
    for (int i = 0; i < [self.checkedCellRows count]; i++) {
        if (indexPath == self.checkedCellRows[i]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];

    //Checked gorceries names and quantities will be put into an array
    NSArray *splitArrayName = [cell.textLabel.text componentsSeparatedByString: @"\u200b"];
    NSArray *splitArrayCategory = [cell.textLabel.text componentsSeparatedByString: @" "];
    NSArray *splitArrayPriceUnit = [cell.detailTextLabel.text componentsSeparatedByString: @" "];
    NSString *checkedGroceryName = [splitArrayName objectAtIndex: 1];
    NSString *checkedGroceryCategory = [splitArrayCategory objectAtIndex:3];
    NSString *checkedGroceryPrice = [splitArrayPriceUnit objectAtIndex:2];
    NSString *checkedGroceryUnit = [splitArrayPriceUnit objectAtIndex:4];
    UITextField *quantityField = (UITextField*)cell.subView;
    CheckedGroceryItem *checkedItem = [[CheckedGroceryItem alloc]init];
    checkedItem.groceryItemString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",checkedGroceryName, checkedGroceryCategory, checkedGroceryPrice, quantityField.text, checkedGroceryUnit];
    checkedItem.quantityField = quantityField;
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [self.checkedGroceries removeObject:checkedItem];
        [self.checkedCellRows removeObject:indexPath];
    }
    else if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [self.checkedGroceries addObject:checkedItem];
        [self.checkedCellRows addObject:indexPath];
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
            for (CheckedGroceryItem* checkedGrocery in self.checkedGroceries) {
                NSArray *splitGrocery = [checkedGrocery.groceryItemString componentsSeparatedByString: @" "];
                NSString *groceryName = [splitGrocery objectAtIndex: 0];
                NSString *groceryCategory = [splitGrocery objectAtIndex: 1];
                NSString *groceryPrice = [splitGrocery objectAtIndex:2];
                NSString *groceryQuantity = checkedGrocery.quantityField.text;
                NSString *groceryUnit = [splitGrocery objectAtIndex:4];
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
            //tripList.trips[i] = trip;
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

@end
