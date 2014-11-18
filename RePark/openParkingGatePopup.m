//
//  openParkingGatePopup.m
//  RePark
//
//  Created by Elad Damari on 11/13/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "openParkingGatePopup.h"
#import "UIViewController+MJPopupViewController.h"

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
    
    NSLog(@"\n data : \n%@", dataDictionary);
    
    
}





@end
