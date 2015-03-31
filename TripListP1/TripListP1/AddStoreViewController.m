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
    
    AppDelegate *app = [AppDelegate instance];
    self.stores = app.stores;
    self.storeItems = app.storeItems;
    
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

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *storeName = [self.storeNames objectAtIndex:row];
    return storeName;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storeItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"foodCell"];
    }
    
    //Create Quanity Field
    UITextField *quantityField = [[UITextField alloc] initWithFrame:CGRectMake(330, 10, 30, 30)];
    quantityField.adjustsFontSizeToFitWidth = YES;
    quantityField.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    quantityField.textColor = [UIColor blackColor];
    quantityField.textAlignment = UITextAlignmentCenter;
    quantityField.keyboardType = UIKeyboardTypeDefault;
    quantityField.returnKeyType = UIReturnKeyDone;
    quantityField.clearButtonMode = UITextFieldViewModeNever;
    [quantityField setEnabled: YES];
    [cell addSubview:quantityField];
    
    //Display Store Item
    GroceryItem *storeItem = [self.storeItems objectAtIndex:indexPath.row];
    NSString *itemDescription = [NSString stringWithFormat:@"\t%@ - %@", storeItem.name, storeItem.category];
    if (storeItem.price != nil) {
        NSString *price = [NSString stringWithFormat:@"\tPrice: %@", storeItem.price];
        cell.detailTextLabel.text = price;
    }
    else {
        cell.detailTextLabel.text = @"\tN/A";
    }
    cell.textLabel.text = itemDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
    else
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)addStore:(id)sender {
    //Create a trip and add it to the sharedTripList
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
