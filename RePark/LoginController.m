//
//  LoginController.m
//  RePark
//
//  Created by Nadav Kershner on 11/3/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;

@end

@implementation LoginController

#pragma mark - IBAction methods

- (IBAction)login:(id)sender {
    
    //check if details are correct
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:kServerAdrress parameters:[self createInfo] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
        if ([responseObject[@"status"] isEqualToString:@"Error"]) {
            
            [UIAlertView alertWithTitle:kAlertMessageDetailsWrong];
            
        } else {
            
            NSDictionary *info = responseObject[@"message"];
                                  
            [[NSUserDefaults standardUserDefaults] setObject:info[@"userAccessToken"] forKey:kAccessToken];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:kSegueHome sender:nil];
        
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [UIAlertView alertWithTitle:@"תקלה בשרת"];
        
         NSLog(@"%@", [error localizedDescription]);
        
    }];
    
}

#pragma mark - Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:_phoneField]) {
        
        [_passwordField becomeFirstResponder];
        
    } else {
    
        [_passwordField resignFirstResponder];

    }
    
    return YES;
    
}

#pragma mark - Private methods

- (NSDictionary*)createInfo{
    
    return @{ @"service"    : @"login",
              @"telephone"  : _phoneField.text,
              @"password"   : _passwordField.text,
              };
    
}

@end
