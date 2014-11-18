//
//  SignUpController.m
//  RePark
//
//  Created by Nadav Kershner on 11/3/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "SignUpController.h"
#import "AFHTTPRequestOperationManager.h"

@interface SignUpController ()

@property (weak, nonatomic) IBOutlet UITextField *firstField;
@property (weak, nonatomic) IBOutlet UITextField *lastField;
@property (weak, nonatomic) IBOutlet UITextField *mailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *verifyField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;

@end

@implementation SignUpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)screenTapped:(id)sender {
    
    [self removeKeyboard];
    
}

-(void)removeKeyboard {
    
    [_firstField resignFirstResponder];
    
    [_lastField resignFirstResponder];
    
    [_mailField resignFirstResponder];
    
    [_phoneField resignFirstResponder];
    
    [_passwordField resignFirstResponder];
    
    [_verifyField resignFirstResponder];
    
}

- (IBAction)send:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kServerAdrress parameters:[self createInfo] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if ([responseObject[@"status"] isEqualToString:@"Error"]) {
            
            [UIAlertView alertWithTitle:kAlertMessageDetailsWrong];
            
        } else {
            
            NSDictionary *info = responseObject[@"message"];
            
            [[NSUserDefaults standardUserDefaults] setObject:info[@"userAccessToken"] forKey:kAccessToken];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:kSegueHome sender:nil];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
    
}

- (NSDictionary*)createInfo{
    
    return @{ @"service"     : @"signup",
              @"first"       : @"sfds",
              @"last"        : @"dsd",
              @"telephone"   : _phoneField.text,
              @"IDnumber"    : @"dsa",
              @"mail"        : _mailField.text,
              @"password"    : _passwordField.text,
              @"gender"      : @"עעוןעןו",
              @"pushID"      : @"dsa"
              };
    
}

@end
