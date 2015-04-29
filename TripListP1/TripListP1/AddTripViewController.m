//
//  AddTripViewController.m
//  TripListP1
//
//  Created by Armand Roelens on 3/26/15.
//  Copyright (c) 2015 CSE 394. All rights reserved.
//

#import "AddTripViewController.h"
#import "Trip.h"
#import "TripList.h"

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tripDatePicker.datePickerMode = UIDatePickerModeDate;
    [self.tripDatePicker setValue:[UIColor colorWithRed:204/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f] forKeyPath:@"textColor"];
    /*SEL selector = NSSelectorFromString(@"setHighlightsToday:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDatePicker instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self.tripDatePicker];*/
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:tapGesture];
    self.tripDatePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval) 0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addTrip:(id)sender {
    UIAlertView *alert = [UIAlertView alloc];
    if ([self.tripNameField.text isEqual: @""]) {
        alert = [alert  initWithTitle:@"Invalid Trip Name"
                        message: @"Please enter a new trip name"
                        delegate:self
                        cancelButtonTitle:nil
                        otherButtonTitles:@"OK",nil];
        [alert show];
        return;
    }
    
    TripList* tripList = [TripList sharedTripList];
    Trip *trip = [[Trip alloc]init];
    trip.name = self.tripNameField.text;
    trip.date = self.tripDatePicker.date;
    trip.shoppingList = [[NSMutableDictionary alloc] init];
    if (tripList.trips == nil) { //This will only occcur if the file is empty
        tripList.trips = [[NSMutableArray alloc]init];
    }
    [tripList.trips addObject:trip];
    
    AppDelegate *app = [AppDelegate instance];
    [app saveTripData];
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController popToViewController:(UIViewController*)self.tripListVC animated:YES];
    NSLog(@"%@ %@", self.tripNameField.text, self.tripDatePicker.date);
}

-(void)hideKeyBoard {
    [self.tripNameField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

@end
