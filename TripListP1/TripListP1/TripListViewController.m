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
    
    //self.tripList = [TripList sharedTripList];
    self.addTripVC = [[AddTripViewController alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /*Parse Test
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
    PFUser *user = [PFUser user];
    user.username = @"my name";
    user.password = @"my pass";
    user.email = @"email@example.com";
    
    // other fields can be set just like with PFObject
    user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
        }
    }];a*/
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
    [dateFormatter setDateFormat:@"MM/dd/YY HH:mm:ss"];
    NSString *theDate = [dateFormatter stringFromDate:trip.date];
    cell.textLabel.text = [NSString stringWithFormat:@"   %@", trip.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"    %@", theDate];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    //Navigate to Store View
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    TripList *tripList = [TripList sharedTripList];
    Trip *trip = [tripList.trips objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:[NSString stringWithFormat:@"   %@", trip.name]]) {
        //self.tripList.currentTrip = trip;
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
    
    [tableView reloadData];
    
    AppDelegate *app = [AppDelegate instance];
    [app saveTripData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end