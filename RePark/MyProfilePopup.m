//
//  MyProfilePopup.m
//  RePark
//
//  Created by Elad Damari on 11/25/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "MyProfilePopup.h"
#import "PXAlertView+Customization.h"
#import "UIViewController+MJPopupViewController.h"

#import "MyParksList.h"

@interface MyProfilePopup ()

@property (weak, nonatomic) IBOutlet UIButton *myPropertiesLabel;

@property (weak, nonatomic) IBOutlet UIButton *myParksLabel;

@property (weak, nonatomic) IBOutlet UIButton *getPayLabel;

@property (weak, nonatomic) IBOutlet UIButton *myCarsLabel;

@property (weak, nonatomic) IBOutlet UIButton *payProperties;


- (IBAction)myPropertiesButton:(id)sender;

- (IBAction)myParksButton:(id)sender;

- (IBAction)getpayButton:(id)sender;

- (IBAction)myCarsButton:(id)sender;

- (IBAction)payPropertiesButton:(id)sender;


@end

@implementation MyProfilePopup


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewsOnScreen];
    
}


- (void) setViewsOnScreen
{
    _myPropertiesLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _myPropertiesLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _myPropertiesLabel.layer.cornerRadius = 5;
    _myPropertiesLabel.layer.borderWidth  = 1;
    
    
    _myParksLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _myParksLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _myParksLabel.layer.cornerRadius = 5;
    _myParksLabel.layer.borderWidth  = 1;
    
    
    _getPayLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _getPayLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _getPayLabel.layer.cornerRadius = 5;
    _getPayLabel.layer.borderWidth  = 1;
    
    
    _myCarsLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _myCarsLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _myCarsLabel.layer.cornerRadius = 5;
    _myCarsLabel.layer.borderWidth  = 1;
    
    
    _payProperties.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _payProperties.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _payProperties.layer.cornerRadius = 5;
    _payProperties.layer.borderWidth  = 1;
    
}



- (IBAction)myPropertiesButton:(id)sender
{
    // nadav ?
    
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה ממתין כרגע להטמעה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];

}

- (IBAction)myParksButton:(id)sender
{
    [self.delegate popUpMyParks:self];
}

- (IBAction)getpayButton:(id)sender
{
    // nadav ?
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה ממתין כרגע להטמעה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
}

- (IBAction)myCarsButton:(id)sender
{
    [self.delegate popUpMyCars:self];
}

- (IBAction)payPropertiesButton:(id)sender
{
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה ממתין כרגע להטמעה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
}




@end
