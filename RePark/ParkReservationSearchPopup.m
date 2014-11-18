//
//  ParkReservationSearchPopup.m
//  RePark
//
//  Created by Elad Damari on 11/16/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkReservationSearchPopup.h"
#import "UIViewController+MJPopupViewController.h"

@interface ParkReservationSearchPopup ()
{
    NSDateFormatter *format;
    int flag;
    NSMutableDictionary     *parametersDictionary;
    CLLocationCoordinate2D addressGeo;
    NSArray *parks;
}

@property (strong, nonatomic)   NSDate      *dateChosen;

@property (strong, nonatomic)   NSString    *dateChosenString;


@property (strong, nonatomic) IBOutlet UITextField *chooseAddressField;

@property (strong, nonatomic) IBOutlet UIDatePicker *reservationPickerView;

@property (strong, nonatomic) IBOutlet UILabel *chooseDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *chooseStartTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *chooseParkingLengthLabel;

@property (strong, nonatomic) IBOutlet UIButton *userHasChosenTitle;


- (IBAction)chooseDate:(id)sender;

- (IBAction)chooseStartTime:(id)sender;

- (IBAction)chooseParkLength:(id)sender;

- (IBAction)searchParksByReservationButton:(id)sender;

- (IBAction)closeButton:(id)sender;

- (IBAction)userHasChosenButton:(id)sender;


@end

@implementation ParkReservationSearchPopup



- (void)viewDidLoad

{
    [super viewDidLoad];
    
    [self setViewsOnScreen];
    
    parks = [[NSArray alloc] init];
    
}


- (IBAction)chooseDate:(id)sender

{
    flag =1;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_reservationPickerView setCalendar:calender];
    [_reservationPickerView setDatePickerMode:UIDatePickerModeDate];
    [_reservationPickerView setHidden:NO];
    [_userHasChosenTitle    setHidden:NO];
    
}


- (IBAction)chooseStartTime:(id)sender

{
    
    flag =2;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_reservationPickerView setCalendar:calender];
    [_reservationPickerView setDatePickerMode:UIDatePickerModeTime];
    [_reservationPickerView setHidden:NO];
    [_userHasChosenTitle    setHidden:NO];
    
}


- (IBAction)chooseParkLength:(id)sender

{
    
    flag = 3;
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [_reservationPickerView setCalendar:calender];
    [_reservationPickerView setDatePickerMode:UIDatePickerModeTime];
    [_reservationPickerView setHidden:NO];
    [_userHasChosenTitle    setHidden:NO];
    
}

- (IBAction)searchParksByReservationButton:(id)sender

{
    
    // set values to save in user defaults...
    
    [[NSUserDefaults standardUserDefaults] setObject:_chooseDateLabel.text
                                                forKey:@"reservationDate"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_chooseStartTimeLabel.text
                                                forKey:@"reservationStart"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_chooseParkingLengthLabel.text
                                                forKey:@"reservationEnd"];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //parse address string to location
    
    NSString *address = [NSString stringWithFormat:@"%@",_chooseAddressField.text];
    
    addressGeo = [self geoCodeUsingAddress:address];
    
    
    // get parameters and send request...
    
    NSDictionary *parameters = [self getParametersForServerRequestName:kSearchParksForReservation
                                                             AndSortBy:kDistance];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
    
}

- (IBAction)closeButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

- (IBAction)userHasChosenButton:(id)sender

{
    if (flag == 1)
    {
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd.MM.yyyy"];
        
        _dateChosen                      = [_reservationPickerView date];
        _dateChosenString                = [format stringFromDate:_dateChosen];
        _chooseDateLabel.text            = _dateChosenString;
        _reservationPickerView.hidden    = YES;
        _userHasChosenTitle.hidden       = YES;
        
       // NSLog(@"\n *** date ChosenString : %@", _dateChosenString);

    }
    
    else if (flag == 2)
    {
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"hh:mm"];

        _dateChosen                      = [_reservationPickerView date];
        _dateChosenString                = [format stringFromDate:_dateChosen];
        _chooseStartTimeLabel.text       = _dateChosenString;
        _reservationPickerView.hidden    = YES;
        _userHasChosenTitle.hidden       = YES;
        
        //NSLog(@"\n *** start time ChosenString : %@", _dateChosenString);
    }
    
    else if (flag == 3)
    {
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"hh:mm"];
        
        _dateChosen                      = [_reservationPickerView date];
        _dateChosenString                = [format stringFromDate:_dateChosen];
        _chooseParkingLengthLabel.text   = _dateChosenString;
        _reservationPickerView.hidden    = YES;
        _userHasChosenTitle.hidden       = YES;
        
        //NSLog(@"\n *** park length ChosenString : %@", _dateChosenString);
        
    }

}


- (void) setViewsOnScreen

{
    
    [_reservationPickerView setHidden:YES];
    
    [_userHasChosenTitle    setHidden:YES];
    
}

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address

{
    
    double latitude = 0, longitude = 0;
    
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if (result)
        
    {
        
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
            
        {
            
            [scanner scanDouble:&latitude];
            
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
                
            {
                
                [scanner scanDouble:&longitude];
                
            }
            
        }
        
    }
    
    CLLocationCoordinate2D center;
    
    center.latitude = latitude;
    
    center.longitude = longitude;
    
    return center;
}

- (NSDictionary *) getParametersForServerRequestName: (NSString *) requestMethod AndSortBy: (NSString *) sortKey

{
    
    parametersDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    [parametersDictionary setObject:accessToken forKey:kAccessToken];
    
    NSString *latitude, *longtitude, *radius;

    latitude   = [NSString stringWithFormat:@"%f", addressGeo.latitude];
        
    longtitude = [NSString stringWithFormat:@"%f", addressGeo.longitude];
    
    radius     = [NSString stringWithFormat:@"%@",
                      [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultRadius]];
    
        
    [parametersDictionary setObject:latitude           forKey:kLatitudeRequest];
        
    [parametersDictionary setObject:longtitude         forKey:kLongtitudeRequest];
        
    [parametersDictionary setObject:radius             forKey:kRadiusRequest];
        
    [parametersDictionary setObject:requestMethod      forKey:kService];
    
    [parametersDictionary setObject:sortKey            forKey:kOrderByRequest];
    
    [parametersDictionary setObject:_chooseDateLabel.text          forKey:@"date"];
    [parametersDictionary setObject:_chooseStartTimeLabel.text     forKey:@"startTime"];
    [parametersDictionary setObject:_chooseParkingLengthLabel.text forKey:@"endTime"];
    
    NSLog(@" dictionary is: %@", parametersDictionary);
        
    return parametersDictionary;
  
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
         
         // ****************************************
         // * call alert to show error             *
         // ****************************************
         
     }];
    
}

- (void) getDataFromResponse: (NSDictionary *) dataDictionary

{
    
    if (dataDictionary)
        
    {

        //NSLog(@"\n *******  search reservations response is:  ******* \n%@", dataDictionary);
        
        NSDictionary *responseDictionary = [dataDictionary objectForKey:@"message"];
        
        NSArray *allKeysArray = [[NSArray alloc] initWithArray:[responseDictionary allKeys]];
        
        NSMutableArray *parkArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[allKeysArray count]; i++)
            
        {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSDictionary *dic = [responseDictionary objectForKey:key];
            
            Park *park = [[Park alloc]initWithInfo:dic];
            
            [parkArray addObject:park];
            
        }
        
        parks = [[NSArray alloc] initWithArray:parkArray];
        
        [self.delegate popUp:self clickedReservation:parks];
        
    }

    
}


#pragma mark - Handle Field Methods

// touch anywhere else closes keyboard

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.view endEditing:YES];
    
}

// hide keyboard after user hit return key.

- (IBAction)hideMyKeyboard:(id)sender

{
    
    // close keyboard...
    
}









@end
