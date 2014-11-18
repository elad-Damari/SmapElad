//
//  EndParkingPopup.m
//  RePark
//
//  Created by Elad Damari on 11/13/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "EndParkingPopup.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"
#import "Park.h"

@interface EndParkingPopup ()

@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *favoriteLabael;

@end


@implementation EndParkingPopup

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    [self setViewsOnScreen];
    
}

- (IBAction)endParkButton:(id)sender

{
    // call relevant method...
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSString *accessToken    = [NSString stringWithFormat:@"%@",
                                [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *carID          = [NSString stringWithFormat:@"%@",
                                [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCarId"]];
    
    NSString *logID          = [NSString stringWithFormat:@"%@",
                                [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultLogId"]];
    
    NSLog(@" log ID from endPArkPopup: %@", logID);
    
    [dic setObject:accessToken         forKey:kAccessToken];
    
    [dic setObject:kEndParkServiceKey  forKey:kService];
    
    [dic setObject:_passedData.parkID  forKey:kParkID];
    
    [dic setObject:carID               forKey:kCarID];
    
    [dic setObject:logID               forKey:kLogID];
    
    [self getParkOkToFinishWithRequestUrl:kServerAdrress andParameters:dic];
}


- (IBAction)clsoeButton:(id)sender

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}


- (IBAction)shareOnFBbutton:(id)sender

{
    NSLog(@"\n shareOnFBbutton");
    

}




- (IBAction)addToFavoritesButton:(id)sender

{
    if ([_passedData.favorit isEqualToString:@"0"])
    {
        _passedData.favorit = @"1";
        
        _favoriteLabael.text = @"V";

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSString *accessToken = [NSString stringWithFormat:@"%@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
        
        [dic setObject:accessToken        forKey:kAccessToken];
        
        [dic setObject:kAddToFavorite     forKey:kService];
        
        [dic setObject:_passedData.parkID forKey:kParkToFavorites];
        
        [self addToFavoriteWithRequestUrl:kServerAdrress andParameters:dic];
        
    }
    
    else
        
    {
        
        _passedData.favorit = @"0";
        
        _favoriteLabael.text = @"X";

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        NSString *accessToken = [NSString stringWithFormat:@"%@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
        
        [dic setObject:accessToken        forKey:kAccessToken];
        
        [dic setObject:kDelFromFavorite   forKey:kService];
        
        [dic setObject:_passedData.parkID forKey:kParkToDelFromFavorites];
        
        [self addToFavoriteWithRequestUrl:kServerAdrress andParameters:dic];
        
    }
    
}

- (void) addToFavoriteWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         NSString *response = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
         NSLog(@"response: %@", response);
         
         
         
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}

- (void) getParkOkToFinishWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

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
    
    
    if (dataDictionary)
        
    {
        
        NSString *status = [dataDictionary objectForKey:@"status"];

        if ([status isEqualToString:@"Success"])
        {
             // alert user with finish & price...
            
            // clear park from user defaults...
            
            [[NSUserDefaults standardUserDefaults] setObject:@""       forKey:kParkID];
            [[NSUserDefaults standardUserDefaults] setObject:@""       forKey:kUserID];
            [[NSUserDefaults standardUserDefaults] setObject:@""       forKey:kSizeID];
            [[NSUserDefaults standardUserDefaults] setObject:@""       forKey:kGateID];
            [[NSUserDefaults standardUserDefaults] setObject:@""    forKey:kParkTopID];
            [[NSUserDefaults standardUserDefaults] setObject:@""   forKey:kParkTypeID];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kParkComments];
            
            [[NSUserDefaults standardUserDefaults] setObject:@""     forKey:kParkImagePath];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kBuildingImagePath];
            
            [[NSUserDefaults standardUserDefaults] setObject:@""    forKey:kAddressID];
            [[NSUserDefaults standardUserDefaults] setObject:@""     forKey:kLatitude];
            [[NSUserDefaults standardUserDefaults] setObject:@""   forKey:kLongtitude];
            [[NSUserDefaults standardUserDefaults] setObject:@""     forKey:kDistance];
            
            [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:kPricePerDay];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kPricePerHour];
            
            [[NSUserDefaults standardUserDefaults] setObject:@""    forKey:kStartTime];
            [[NSUserDefaults standardUserDefaults] setObject:@""      forKey:kEndTime];
            [[NSUserDefaults standardUserDefaults] setObject:@""   forKey:kTimeRemain];
            [[NSUserDefaults standardUserDefaults] setObject:@""   forKey:kIsTakenNow];
            
            [[NSUserDefaults standardUserDefaults] setObject:@""  forKey:kRankCounter];
            [[NSUserDefaults standardUserDefaults] setObject:@""    forKey:kRankTotal];
            [[NSUserDefaults standardUserDefaults] setObject:@""      forKey:kFavorit];
            
            [[NSUserDefaults standardUserDefaults] synchronize];

            
        }
        
        // alert user somthig went wrong...
       

    }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}


- (void) setViewsOnScreen

{
    
    //get total time of parking...

    if ([_passedData.favorit isEqualToString:@"0"])
    {
         _favoriteLabael.text = @"X";
    }
    else _favoriteLabael.text = @"V";
    
    

    NSDate *time = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh-mm"];
    NSString *currentTime = [dateFormatter stringFromDate: time];
    NSString *startTime   = _passedData.startTime;
    
    NSLog(@"\n *** park end times are: %@ , %@", startTime, currentTime);
    
    NSLog(@"\n *** price per hour: %@",_passedData.pricePerHour);
    
    int startHours, startMinutes, endHours, endMinutes,  resultHours,resultMinutes;
    
    NSArray *startArray = [startTime componentsSeparatedByString:@"-"];
    
    NSArray *endArray   = [currentTime componentsSeparatedByString:@"-"];

    endHours            = [endArray[0]   intValue];
    
    endMinutes          = [endArray[1]   intValue];
    
    startHours          = [startArray[0] intValue];
    
    startMinutes        = [startArray[1] intValue];
    
    
    if (endHours - startHours >= 0)
    {
        resultHours = endHours - startHours;
    }
    else
    {
        resultHours = (startHours + 12) - endHours;
    }
    
    if (endMinutes - startMinutes >= 0)
    {
        resultMinutes = endMinutes - startMinutes;
    }
    else
    {
        resultMinutes = (endMinutes + 60) - startMinutes;
        
        resultHours --;
    }
    
    
    
    int pricePerHour           = [_passedData.pricePerHour intValue];
    
    float pricePerMinute         = pricePerHour/60;
    
    
    float totalPricePerHours   = resultHours   * pricePerHour;
    
    float totalPricePerMinutes = resultMinutes * pricePerMinute;
    
    float finallPrice = totalPricePerHours + totalPricePerMinutes;
    
    int finalllll = finallPrice;

    _finallPriceLabel.text     = [NSString stringWithFormat:@"%d", finalllll];
    
    
    
    NSString *hoursResult      = [NSString stringWithFormat:@"%d", resultHours];
    
    NSString *minutesResult    = [NSString stringWithFormat:@"%d", resultMinutes];
    
    if (resultHours<10) hoursResult    = [NSString stringWithFormat:@"0%@",hoursResult];
    
    if (resultMinutes<10) minutesResult = [NSString stringWithFormat:@"0%@",minutesResult];
    
    
    _totalTimeLabel.text = [NSString stringWithFormat:@"%@:%@", hoursResult, minutesResult];
    
    
}





@end
