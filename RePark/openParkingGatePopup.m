//
//  openParkingGatePopup.m
//  RePark
//
//  Created by Elad Damari on 11/13/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "openParkingGatePopup.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"

@interface openParkingGatePopup ()

@end

@implementation openParkingGatePopup


- (void)viewDidLoad

{
    
    [super viewDidLoad];

}

- (IBAction)openGateButton:(id)sender

{
    NSLog(@"gate value is: %@",_passedData.gateID);
    
    // gate has phone opening machanism ...
    if ([_passedData.gateID isEqualToString:@"3"])
    
    {
        NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
        
        NSDictionary *parameters = [self getParametersForRequest:kDistance];
        
        [self getParksListWithRequestUrl:requestUrl andParameters:parameters];

    }
    
    else
    {
        // log user that gate has no phone opening machanism ...
        NSLog(@" no phone opening machanism ...");
        
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"לא ניתן לפתוח שער !"
                                                    message:@"לצערנו, כרגע לשער זה אין מנגנון פתיחה באמצעות חיוג."
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
                             {
                                 if (cancelled)
                                 {
                                     NSLog(@"Simple Alert View cancelled");
                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                 }
                                 else
                                 {
                                     NSLog(@"Simple Alert View dismissed, but not cancelled");
                                     
                                 }}];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
    }
    
}

- (IBAction)closeButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

- (NSDictionary *) getParametersForRequest: (NSString *) sortKey

{

    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *logId = [NSString stringWithFormat:@"%@",
                       [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLogId"]];
    
    NSLog(@"\n log id is: %@", logId);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:accessToken        forKey:kAccessToken];
    
    [dic setObject:kOpenParkGate      forKey:kService];
    
    [dic setObject:logId              forKey:kLogID];
    
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
    NSString *status = [dataDictionary objectForKey:@"status"];
    
    if ([status isEqualToString:@"Success"])
    {
        //NSString *message = [dataDictionary objectForKey:@"message"];
        
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
                                                    message:[dataDictionary objectForKey:@"message"]
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
                             {
                                 if (cancelled)
                                 {
                                     NSLog(@"Simple Alert View cancelled");
                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                 }
                                 else
                                 {
                                     NSLog(@"Simple Alert View dismissed, but not cancelled");
                                     
                                 }}];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];

    }
    
//    else
//    {
//        
//        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
//                                                    message:[dataDictionary objectForKey:@"message"]
//                                                cancelTitle:@"אישור"
//                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
//                             {
//                                 if (cancelled)
//                                 {
//                                     NSLog(@"Simple Alert View cancelled");
//                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
//                                 }
//                                 else
//                                 {
//                                     NSLog(@"Simple Alert View dismissed, but not cancelled");
//                                     
//                                 }}];
//        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
//        
//    }
   
    
    
    
}





@end
