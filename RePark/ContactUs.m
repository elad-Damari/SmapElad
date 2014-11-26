//
//  ContactUs.m
//  RePark
//
//  Created by Elad Damari on 11/25/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ContactUs.h"
#import <MessageUI/MessageUI.h>
#import "PXAlertView+Customization.h"
#import "UIViewController+MJPopupViewController.h"

@interface ContactUs ()

@property (weak, nonatomic) IBOutlet UIButton *sendMail;

@property (weak, nonatomic) IBOutlet UIButton *callUs;


- (IBAction)sendMailButton:(id)sender;

- (IBAction)callUsButton:(id)sender;


@end

@implementation ContactUs

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setViewsOnScreen];
}

- (void) setViewsOnScreen
{
    _sendMail.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _sendMail.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _sendMail.layer.cornerRadius = 5;
    _sendMail.layer.borderWidth  = 1;
    
    
    _callUs.titleLabel.textColor =
    [UIColor colorWithRed:(12/255.0) green:(191/255.0) blue:(165/255.0) alpha:1];
    _callUs.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    _callUs.layer.cornerRadius = 5;
    _callUs.layer.borderWidth  = 1;
    
    
}


- (IBAction)sendMailButton:(id)sender
{
    
    NSLog(@" presssssss");
    
    // Email Subject
    NSString *emailTitle = @"פניה לשירות לקוחות";
    // Email Content
    NSString *messageBody = @"אנא צרו איתי קשר לגבי הנושאים הבאים:";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"tamar.navigazo@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

- (IBAction)callUsButton:(id)sender
{
    NSString *phoneNumber = [NSString stringWithFormat:@"tel://0525413136"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}

- (IBAction)test:(id)sender
{
    NSLog(@"test");
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSelector:@selector(closeAfterDelay) withObject:nil afterDelay:0.01];
}

- (void) closeAfterDelay
{
   [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}









@end
