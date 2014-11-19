//
//  ParkExtensionPopup.m
//  RePark
//
//  Created by Elad Damari on 11/13/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkExtensionPopup.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"

@interface ParkExtensionPopup ()
{
    NSString *str;
}

@property (weak, nonatomic) IBOutlet UILabel *extensionPriceLabel;

- (IBAction)cancelButton:(id)sender;

- (IBAction)extensionButton:(id)sender;

@end


@implementation ParkExtensionPopup


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _extensionPriceLabel.text = @"00";
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_timePickerView setCalendar:calender];

    
    [_timePickerView setDatePickerMode:UIDatePickerModeTime];
    
    [_timePickerView addTarget:self
                   action:@selector(dateChanged:)
         forControlEvents:UIControlEventValueChanged];
    
}

- (void)dateChanged:(id)sender
{

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"hh:mm"];
    
    NSString *string = [format stringFromDate:[_timePickerView date]];

    
    int resultHours,resultMinutes;
    
    NSArray *startArray = [string componentsSeparatedByString:@":"];

    resultHours          = [startArray[0] intValue];
    
    resultMinutes        = [startArray[1] intValue];

    
    int pricePerHour           = 5;
    
    float pricePerMinute         = pricePerHour/60;
    
    
    float totalPricePerHours   = resultHours   * pricePerHour;
    
    float totalPricePerMinutes = resultMinutes * pricePerMinute;
    
    float finallPrice = totalPricePerHours + totalPricePerMinutes;
    
    int finalllll = finallPrice;
    
    
    
    string  = [NSString stringWithFormat:@"%d", finalllll];
    
    NSLog(@"Date changed: %@", string);
    
    _extensionPriceLabel.text = string;
}


- (IBAction)cancelButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}


- (IBAction)extensionButton:(id)sender

{

    NSDictionary *parameters = [self getParametersForRequest:kDistance];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
    
}

- (NSDictionary *) getParametersForRequest: (NSString *) sortKey

{
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *logID = [NSString stringWithFormat:@"%@",
                       [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLogId"]];
    
    NSLog(@"log ID from extension is: %@", logID);

    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:accessToken        forKey:kAccessToken];
    
    [dic setObject:kAskForExtension   forKey:kService];
    
    [dic setObject:logID              forKey:kLogID];
    
    [dic setObject:_extensionPriceLabel.text forKey:kTimeToExtend];
    
    return dic;
    
}

- (void) getParksListWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         [self getDataFromResponse:responseObject];
         
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}

- (void) getDataFromResponse: (NSDictionary *) dataDictionary

{
    
    NSLog(@"\n data : \n%@", dataDictionary);
    
    NSString *status = [dataDictionary objectForKey:@"status"];
    
    if ([status isEqualToString:@"Success"])
    {
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
                                                    message:@" פנייתך תועבר לבעל החניה ובהמשך תקבל עידכון האם פנייתך אושרה."
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
        {
            
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
        
        }
                             ];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];

    }
    
    else
        
    {
        
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
                                                    message:@"לצערנו, כרגע לא ניתן להאריך את החניה."
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
        {
            
            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
        
        }
                             ];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
}









@end
