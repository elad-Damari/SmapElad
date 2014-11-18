//
//  ParkExtensionPopup.m
//  RePark
//
//  Created by Elad Damari on 11/13/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkExtensionPopup.h"
#import "UIViewController+MJPopupViewController.h"

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
    
    
    
    //NSDate *date = [[NSDate alloc] init];
    //[_timePickerView setDate:date animated:YES];
    
    

//    NSDate * now = [[NSDate alloc] init];
//    NSDateComponents * comps = [calender components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
//    [comps setHour:0];
//    [comps setMinute:0];
    
    
    
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"h:mm a"];
//    _extensionPriceLabel.text = [outputFormatter stringFromDate:_timePickerView.date];
    
    
    //UIDatePicker *datePicker;
    
//    _timePickerView = [[UIDatePicker alloc]init];
//    [_timePickerView setDate:[NSDate date]];
//    [_timePickerView setDatePickerMode:UIDatePickerModeDate];
//    [_timePickerView removeTarget:self action:nil forControlEvents:UIControlEventValueChanged];
//    [_timePickerView addTarget:self action:@selector(updateTextFieldDate:)     forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)dateChanged:(id)sender
{
    //UIDatePicker *datePicker = (UIDatePicker *)sender;
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
    
    NSString *str = [dataDictionary objectForKey:@"status"];
    
    if ([str isEqualToString:@"Success"])
    {
        // alert extension sent to user ....
    }
    else
    {
        // alert something went wrong...
    }
    
}









@end
