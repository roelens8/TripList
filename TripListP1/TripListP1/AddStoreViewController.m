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
    self.stores = [[NSMutableArray alloc]init];
    self.storeItems = [[NSMutableArray alloc]init];
    self.storeNames = [[NSMutableArray alloc]init];
    self.checkedGroceries = [[NSMutableArray alloc]init];
    self.checkedCellRows = [[NSMutableArray alloc] init];
    
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
    return [self.stores count];
}

//Not needed because of viewForRow methods
/*- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *storeName = [self.storeNames objectAtIndex:row];
    return storeName;
}*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.storeItems count];
}

//Editing the pickerView
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* textView = (UILabel*)view;
    if (!textView){
        textView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 65, 15)];
        textView.adjustsFontSizeToFitWidth = YES;
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setFont:[UIFont boldSystemFontOfSize:15]];
        [textView setText:[self.storeNames objectAtIndex:row]];
    }
    return textView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSArray *splitArrayPrice = [cell.detailTextLabel.text componentsSeparatedByString: @" "];
    NSString *checkedGroceryName = [splitArrayName objectAtIndex: 1];
    NSString *checkedGroceryCategory = [splitArrayCategory objectAtIndex: 2];
    NSString *checkedGroceryPrice = [splitArrayPrice objectAtIndex: 1];
    UITextField *quantityField = (UITextField*)cell.subView;
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [self.checkedGroceries removeObject:[NSString stringWithFormat:@"%@ %@ %@ %@",checkedGroceryName, checkedGroceryCategory, checkedGroceryPrice, quantityField.text]];
        [self.checkedCellRows removeObject:indexPath];
    }
    else if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [self.checkedGroceries addObject:[NSString stringWithFormat:@"%@ %@ %@ %@",checkedGroceryName, checkedGroceryCategory, checkedGroceryPrice, quantityField.text]];
        [self.checkedCellRows addObject:indexPath];
    }
}

- (void)addStore:(id)sender {
    //Create a store and add it to the sharedTripList then save it
    TripList* tripList = [TripList sharedTripList];
    Trip *trip = [[Trip alloc]init];
    for (int i = 0; i < [tripList.trips count]; i++) {
        if (tripList.currentTrip == tripList.trips[i]) {
            NSMutableArray *groceries = [[NSMutableArray alloc]init];
            trip = tripList.trips[i];
            for (NSString* checkedGrocery in self.checkedGroceries) {
                NSArray *splitGrocery = [checkedGrocery componentsSeparatedByString: @" "];
                NSString *groceryName = [splitGrocery objectAtIndex: 0];
                NSString *groceryCategory = [splitGrocery objectAtIndex: 1];
                NSString *groceryPrice = [splitGrocery objectAtIndex:2];
                NSString *groceryQuantity = [splitGrocery objectAtIndex:3];
                if ([groceryPrice isEqualToString:@"N/A"] || [groceryPrice isEqualToString:@""])
                    groceryPrice = @"0.00";
                
                GroceryItem *grocery = [[GroceryItem alloc]init];
                grocery.name = groceryName;
                grocery.category = groceryCategory;
                grocery.price = groceryPrice;
                grocery.quantity = groceryQuantity;
                [groceries addObject:grocery]; //Add grocery to grocery list
            }
            NSInteger row = [self.storePicker selectedRowInComponent:0];
            StoreLocation *pickerStore = [self.stores objectAtIndex:row];
            NSString* storeName = pickerStore.name;
            //If Store is already in the store list, then alert
            for (NSString *storeTemp in [trip.shoppingList allKeys]) {
                if ([storeName isEqualToString:storeTemp]) {
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
            [trip.shoppingList setObject:groceries forKey:storeName];
            tripList.currentTrip = trip;
            tripList.trips[i] = trip;
            break;
        }
    }
    [self saveTripData];
    [self.navigationController popViewControllerAnimated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
