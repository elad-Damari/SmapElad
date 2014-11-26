//
//  SystemProperties.m
//  RePark
//
//  Created by Elad Damari on 11/25/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "SystemProperties.h"
#import "PXAlertView+Customization.h"
#import "UIViewController+MJPopupViewController.h"

#import <MessageUI/MessageUI.h>
#import <FacebookSDK/FacebookSDK.h>


NSString *const site = @"http://www.navigazo.com/mobile";


@interface SystemProperties ()

@property (weak, nonatomic) IBOutlet UIButton *termsOfUseLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareLabel;

@property (weak, nonatomic) IBOutlet UIButton *rankLabel;

@property (weak, nonatomic) IBOutlet UIButton *contactUsLabel;

@property (weak, nonatomic) IBOutlet UIButton *blocked;


- (IBAction)termsOfUseButton:(id)sender;

- (IBAction)shareButton:(id)sender;

- (IBAction)rankButton:(id)sender;

- (IBAction)contactUsButton:(id)sender;

- (IBAction)blockedButton:(id)sender;



@end

@implementation SystemProperties

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setViewsOnScreen];
}

- (void) setViewsOnScreen
{
    _termsOfUseLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _termsOfUseLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _termsOfUseLabel.layer.cornerRadius = 5;
    _termsOfUseLabel.layer.borderWidth  = 1;
    
    
    _shareLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _shareLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _shareLabel.layer.cornerRadius = 5;
    _shareLabel.layer.borderWidth  = 1;
    
    
    _rankLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _rankLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _rankLabel.layer.cornerRadius = 5;
    _rankLabel.layer.borderWidth  = 1;
    
    
    _contactUsLabel.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _contactUsLabel.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _contactUsLabel.layer.cornerRadius = 5;
    _contactUsLabel.layer.borderWidth  = 1;
    
    
    _blocked.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _blocked.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _blocked.layer.cornerRadius = 5;
    _blocked.layer.borderWidth  = 1;
    
}



- (IBAction)termsOfUseButton:(id)sender

{
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה ממתין כרגע להטמעה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
    
}

- (IBAction)shareButton:(id)sender
{
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"שתף חברים באפליקציה !"
                                                 message:@"כיצד תרצה לשתף ?"
                                             cancelTitle:@"פייסבוק"
                                             otherTitles:@[@"ווטסאפ", @"מייל", @"SMS"]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0)
                                                  {
                                                      // facebook...
                                                      FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
                                                      
                                                      params.link = [NSURL URLWithString:site];
                                                      
                                                      if ([FBDialogs canPresentShareDialogWithParams:params]) {
                                                          
                                                          [FBDialogs presentShareDialogWithLink:params.link handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                              if(error) {
                                                                  
                                                                  NSLog(@"Error publishing story: %@", error.description);
                                                                  
                                                              } else {
                                                                  
                                                                  NSLog(@"result %@", results);
                                                                  
                                                              }
                                                          }];
                                                          [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                                      } else
                                                      {
                                                          
                                                          //alert error
                                                          
                                                      }
                                                  }
                                                  else if (buttonIndex == 1)
                                                  {
                                                      NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@", site]];
                                                      
                                                      if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                          
                                                          [[UIApplication sharedApplication] openURL:url];
                                                          
                                                      } else
                                                      {
                                                          
                                                          //alert error
                                                          
                                                      }
                                                  }
                                                  else if (buttonIndex == 2)
                                                  {
                                                      if ([MFMessageComposeViewController canSendText]) {
                                                          
                                                          NSString *message = site;
                                                          
                                                          MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
                                                          
                                                          mc.messageComposeDelegate = self;
                                                          
                                                          [mc setBody:message];
                                                          
                                                          [self presentViewController:mc animated:YES completion:nil];
                                                          
                                                      } else
                                                      {
                                                          
                                                          // alert error
                                                          
                                                      }
                                                  }
                                                  else if (buttonIndex == 3)
                                                  {
                                                      
                                                  }}];
    
    [alert setAllButtonsBackgroundColor:[UIColor grayColor]];
}

- (IBAction)rankButton:(id)sender
{
    
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"יפנה לדירוג האפליקציה ב AppStore"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
    
}

- (IBAction)contactUsButton:(id)sender
{
    
    [self.delegate popUpContactUs:self];
    
}

- (IBAction)blockedButton:(id)sender
{
    
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה נמצא כרגע בבניה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];

    
}
@end
