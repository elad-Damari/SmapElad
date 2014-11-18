//
//  ForgotPasswordController.m
//  RePark
//
//  Created by Nadav Kershner on 11/5/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ForgotPasswordController.h"

@interface ForgotPasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ForgotPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)send:(id)sender{
    
    //alert
    
    [self performSegueWithIdentifier:@"reset" sender:nil];
    
}

@end
