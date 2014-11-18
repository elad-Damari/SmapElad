//
//  ParkingSupportPopup.m
//  RePark
//
//  Created by Elad Damari on 11/12/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkingSupportPopup.h"
#import "UIViewController+MJPopupViewController.h"


@interface ParkingSupportPopup ()

- (IBAction)callParkOwnerButton:(id)sender;

- (IBAction)callCustomerServiceButton:(id)sender;

- (IBAction)closeButton:(id)sender;


@end

@implementation ParkingSupportPopup


- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    NSLog(@" data passed is: %@", _passedData);
    
   
}


#pragma mark - Action Methods

// call Park Owner

- (IBAction)callParkOwnerButton:(id)sender

{
    
    // **************************************************************
    // * get actual park owner number (park details), not hardcoded *
    // **************************************************************
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"parkOwnerNumber"]];
    
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:phoneNumber]];
    
}


// callCustomerService

- (IBAction)callCustomerServiceButton:(id)sender

{
    
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:@"costumerSupportNumber"]];
    
    [[UIApplication sharedApplication] openURL:
     [NSURL URLWithString:phoneNumber]];
}


// dissmis popup

- (IBAction)closeButton:(id)sender

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}










@end
