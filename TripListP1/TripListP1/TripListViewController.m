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
    
    self.tripList = [TripList sharedTripList];
    
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
    return [self.tripList.trips count];;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"tripCell"];
    }
    
    Trip *trip = [self.tripList.trips objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YY HH:mm:ss"];
    NSString *theDate = [dateFormatter stringFromDate:trip.date];
    cell.textLabel.text = [NSString stringWithFormat:@"   %@", trip.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"    %@", theDate];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    //Navigate to Store View
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    Trip *trip = [self.tripList.trips objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:[NSString stringWithFormat:@"   %@", trip.name]]) {
        self.tripList.currentTrip = trip;
    }
    self.storeListVC = [[StoreListViewController alloc]init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    self.storeListVC = [storyboard instantiateViewControllerWithIdentifier:@"storeList"];
    [self.navigationController pushViewController:self.storeListVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addTrip"]) {
        self.addTripVC = (AddTripViewController *)segue.destinationViewController;
        self.addTripVC.tripListVC = self;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableData removeObjectAtIndex:indexPath.row];
    [self.tripList.trips removeObjectAtIndex:indexPath.row];
    
    [tableView reloadData];
    
    [self.addTripVC saveTripData];
}

@end