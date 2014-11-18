//
//  ValidateController.m
//  RePark
//
//  Created by Nadav Kershner on 11/7/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ValidateController.h"

@interface ValidateController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeField;

@end

@implementation ValidateController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _phoneLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [_codeField becomeFirstResponder];

}
- (IBAction)sendAgain:(id)sender {
}
- (IBAction)callMe:(id)sender {
}

- (IBAction)send:(id)sender {
    
    if ([_codeField.text isEqualToString:@""]) {
        
        [UIAlertView alertWithTitle:@"מספר לא תקין"];

    } else {
    
        [self performSegueWithIdentifier:@"SignUp" sender:nil];
        
    }
    
    /*
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kServerAdrress parameters:[self createInfo] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        if ([responseObject[@"status"] isEqualToString:@"Error"]) {
            
            [UIAlertView alertWithTitle:kAlertMessageDetailsWrong];
            
        } else {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
     
     */
    
}

- (NSDictionary*)createInfo{

    return @{ @"service"    : @"validatePhone",
              @"telephone"  : _codeField.text };

}

- (IBAction)screenTapped:(id)sender{

    [self removeKeyboard];
    
}

- (void)removeKeyboard{

    [_codeField resignFirstResponder];

}

@end
