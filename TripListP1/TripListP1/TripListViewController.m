//
//  TripListViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/24/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "TripListViewController.h"

@interface TripListViewController ()

@end

@implementation TripListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Back";
    self.navigationController.navigationBar.hidden = YES;
    
    self.addTripVC = [[AddTripViewController alloc] init];
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
    return [tripList.trips count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:@"tripCell"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"tripCell"];
    }
    
    TripList *tripList = [TripList sharedTripList];
    Trip *trip = [tripList.trips objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *usFormatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM hh:mm a" options:0 locale:usLocale];
    [dateFormatter setDateFormat:usFormatString];

    NSString *theDate = [dateFormatter stringFromDate:trip.date];
    cell.textLabel.text = [NSString stringWithFormat:@"   %@", trip.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"    %@", theDate];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    cell.textLabel.textColor = [UIColor colorWithRed:(205/255.0) green:(0/255.0) blue:(0/255.0) alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    //Navigate to Store View
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    Trip *trip = [tripList.trips objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:[NSString stringWithFormat:@"   %@", trip.name]]) {
        tripList.currentTrip = trip;
    }
    self.storeListVC = [[StoreListViewController alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.storeListVC = [storyboard instantiateViewControllerWithIdentifier:@"storeList"];
    [self.navigationController pushViewController:self.storeListVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*if ([segue.identifier isEqualToString:@"addTrip"]) {
        self.addTripVC = (AddTripViewController *)segue.destinationViewController;
        self.addTripVC.tripListVC = self;
    }*/
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    TripList *tripList = [TripList sharedTripList];
    [tripList.trips removeObjectAtIndex:indexPath.row];
    
    //[tableView reloadData];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    AppDelegate *app = [AppDelegate instance];
    [app saveTripData];
    //[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)logout:(UIButton *)sender {
    [PFUser logOut];
    [PFUser currentUser]; // this will now be nil
}

@end