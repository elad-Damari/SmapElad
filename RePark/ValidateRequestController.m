//
//  ValidateRequestController.m
//  RePark
//
//  Created by Nadav Kershner on 11/8/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ValidateRequestController.h"
#import "UIViewController+MJPopupViewController.h"
#import "MJPopUpController.h"

@interface ValidateRequestController () <MJPopUpControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *countryButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (strong, nonatomic) NSArray *countries;

@end

@implementation ValidateRequestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.countries = @[@"Israel  +972", @"United States  +1"];
    
    [_countryButton setTitle:self.countries[0] forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [_phoneField becomeFirstResponder];
    
}

- (IBAction)pickCountry:(id)sender {
    
    [self removeKeyborad:self.view];
    
    MJPopUpController *vc = [[MJPopUpController alloc] init];
    
    vc.list = self.countries;
    
    vc.delegate = self;
    
    [self presentPopupViewController:vc animationType:MJPopupViewAnimationFade];
}

- (IBAction)send:(id)sender {
    
    if ([_phoneField.text isEqualToString:@""]) {
        
        [UIAlertView alertWithTitle:@"מספר לא תקין"];
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:_phoneField.text forKey:@"phone"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"Validate" sender:nil];
        
    }
    
}

- (void)popUp:(MJPopUpController *)popUpController clickedRowAtIndex:(NSUInteger)index{
    
    [_countryButton setTitle:self.countries[index] forState:UIControlStateNormal];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
}

@end
