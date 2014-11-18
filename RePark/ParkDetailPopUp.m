//
//  ParkDetailPopUp.m
//  RePark
//
//  Created by Elad Damari on 11/10/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkDetailPopUp.h"
#import "Park.h"
#import "StartParkingPopUp.h"
#import "AFNetworking.h"
#import "UIViewController+MJPopupViewController.h"


@interface ParkDetailPopUp ()

{
    
    NSString *minute, *hour;

}

@property (nonatomic, strong) NSMutableArray *minutes;
@property (nonatomic, strong) NSMutableArray *hours;
@property (strong, nonatomic) IBOutlet UIPickerView *timesPickerView;

@property (weak, nonatomic) IBOutlet UILabel *sundayLabel;
@property (weak, nonatomic) IBOutlet UILabel *mondayLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *wednesdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *thursdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *fridayLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturdayLabel;

@property (weak, nonatomic) IBOutlet UILabel *parkIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkDailyPrice;
@property (weak, nonatomic) IBOutlet UILabel *parkDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkGateLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkFavoriteLabel;

@property (weak, nonatomic) IBOutlet UIImageView *parkingImagView;
@property (weak, nonatomic) IBOutlet UIImageView *parkingBuildingImageView;



- (IBAction)startParkingButton:(id)sender;

- (IBAction)reservParkingButton:(id)sender;

- (IBAction)cancelButton:(id)sender;


- (IBAction)openParkingImageButton:(id)sender;

- (IBAction)openBuildingImageButton:(id)sender;


@end

@implementation ParkDetailPopUp


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    NSLog(@"parking  spot ID is: %@", _parkingSpotToPass.parkID);
    
    // ******** picker test ***********
    
    _timesPickerView = [[UIPickerView alloc] init];
    _minutes         = [[NSMutableArray alloc] init];
    _hours           = [[NSMutableArray alloc] init];
    
    for ( int i=0; i<60; i++)
    {
        if (i<10)
        {
             [_minutes addObject:[NSString stringWithFormat:@"0%d", i]];
        }
        else [_minutes addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for ( int i=0; i<24; i++)
    {
        if (i<10)
        {
             [_hours addObject:[NSString stringWithFormat:@"0%d", i]];
        }
        else [_hours addObject:[NSString stringWithFormat:@"%d", i]];
    }

    [[_timesPickerView delegate] pickerView:_timesPickerView didSelectRow:10 inComponent:10];
    
    // ******** picker finished ***********
    
    [self getParkDetails];
 
}


#pragma mark - Action Methods

- (IBAction)startParkingButton:(id)sender

{
    // *******************
    


        NSString *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
        
        NSDictionary *parameters = [self getParametersForStartPark:_parkingSpotToPass.parkID];
        
        NSLog(@" parameters are: %@", parameters.description);
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         
         {
             
             [self getDataFromResponse2:responseObject];
             
             //NSLog(@"response from details  is: %@", responseObject);
             
             
         }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         
         {
             
             NSLog(@"\n ***** Error: %@", error);
             
         }];

}
        
        
- (void) getDataFromResponse2: (NSDictionary *) dataDictionary
        
    {
        
        if (dataDictionary)
            
        {
            NSLog(@"dataDictionary: %@", dataDictionary);
            
            if ([[dataDictionary objectForKey:@"status"] isEqualToString:@"Success"])
                
            {
                
                NSDictionary *dictionary = [dataDictionary objectForKey:@"message"];
                
                NSString *parkingLogId = [NSString stringWithFormat:@"%@",
                                          [dictionary objectForKey:@"logID"]];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:parkingLogId          forKey:@"defaultLogId"];

                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                NSLog(@"\n *** log ID is: %@", parkingLogId);
                
                if (hour == nil) hour = @"00";
                
                if (minute == nil) minute = @"00";
                
                if ([hour intValue] == 0 && [minute intValue] == 0)
                {
                    NSLog(@" no time");
                }
                else
                {
                    _parkingSpotToPass.timeRemain = [NSString stringWithFormat:@"%@:%@", hour, minute] ;
                    
                    NSLog(@"\n\n ***_parkingSpotToPass.timeRemain: %@", _parkingSpotToPass.timeRemain);
                    
                    [self.delegate popUp:self clickedButton:_parkingSpotToPass];
                }
                
                
                
            }
            
            else
                
            {
                
                // **********************************************************
                // * handle error, tell user what went wrong - show message *
                // **********************************************************
                
                NSString *error = [dataDictionary objectForKey:@"message"];
                
                NSLog(@"\n sorry but, %@", error);
                
            }
            
        }
        
    }


- (NSDictionary *) getParametersForStartPark: (NSString *) parkId

{
    
    NSString *accessToken    = [NSString stringWithFormat:@"%@",
                                [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *defaultCar   = [NSString stringWithFormat:@"%@",
                                [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCarId"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:accessToken           forKey:kAccessToken];
    
    [dic setObject:kStartParkServiceKey  forKey:kService];
    
    [dic setObject:parkId                forKey:kParkID];
    
    [dic setObject:defaultCar          forKey:kCarID];
    
    return dic;
    
}


- (IBAction)reservParkingButton:(id)sender

{
    
    //******************************************************************************
    NSLog(@"reserv Parking window");
    
    // ****************************************
    // * open reserv Parking window           *
    // ****************************************
    
    //[self.delegate popUp:self clickedButton:_parkingSpotToPass];
    
}

- (IBAction)cancelButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

- (IBAction)openParkingImageButton:(id)sender

{
    NSLog(@"open image");
    
    // ****************************************
    // * open image to full screen?           *
    // ****************************************
}

- (IBAction)openBuildingImageButton:(id)sender

{
    NSLog(@"open image");
    
    // ****************************************
    // * open image to full screen?           *
    // ****************************************
}


#pragma mark - server connection methods


// get parameters for server request

- (NSDictionary *) getParametersForRequestWithParkID: (NSString *) parkId

{
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:accessToken            forKey:kAccessToken];
    
    [dic setObject:kGetParkSlots          forKey:kService];
    
    [dic setObject:parkId                 forKey:kParkID];
    
    return dic;
    
}


// get park details from server

- (void) getParkDetails

{
    
    NSDictionary *parameters = [self getParametersForRequestWithParkID:_parkingSpotToPass.parkID];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kServerAdrress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {

         [self getDataFromResponse:responseObject];
         
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"\n ***** Error: %@", error);
         
     }];
    
}


// parse response from server

- (void) getDataFromResponse: (NSDictionary *) dataDictionary

{
    
    NSLog(@"\n *** Parking Spots Details: ***\n  %@", dataDictionary);
    
    if (dataDictionary)
        
    {
        
        NSDictionary *slots = [dataDictionary objectForKey:@"message"];

        [self setLabelsWithParkInfo:_parkingSpotToPass andParkDetails:slots];

    }
    
}


- (IBAction)addToFavorite:(UIButton *)sender
{

        if ([_parkFavoriteLabel.text isEqualToString:@"X"])
        {
            _parkFavoriteLabel.text = @"V";

            NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
            
            //params dic
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
            
            [dic setObject:accessToken        forKey:kAccessToken];
            
            [dic setObject:kAddToFavorite     forKey:kService];
            
            [dic setObject:_parkingSpotToPass.parkID   forKey:kParkToFavorites];
            
            [self addToFavoriteWithRequestUrl:requestUrl andParameters:dic];
            
        }
        else
        {
            _parkFavoriteLabel.text = @"X";
            
            NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
            
            //params dic
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
            
            [dic setObject:accessToken        forKey:kAccessToken];
            
            [dic setObject:kDelFromFavorite   forKey:kService];
            
            [dic setObject:_parkingSpotToPass.parkID  forKey:kParkToDelFromFavorites];
            
            [self addToFavoriteWithRequestUrl:requestUrl andParameters:dic];
            
            //mypark.favorit = @"0";
            
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




// set labels with park details info

- (void) setLabelsWithParkInfo: (Park *) park andParkDetails: (NSDictionary *) slots

{
    
    _parkIdLabel.text       = park.parkID;
    
    _parkLocationLabel.text = park.addressID;
    
    _parkPriceLabel.text    = park.pricePerHour;
    
    _parkDailyPrice.text    = park.pricePerDay;
    
    
    // replace default values with values from initial methods...
    
    _parkDistanceLabel.text = [NSString stringWithFormat:@"%d",[park.distance intValue]];
    
    _parkSizeLabel.text     = [[NSUserDefaults standardUserDefaults] objectForKey:
                                [NSString stringWithFormat:@"size%@", park.sizeID]];
    
    _parkGateLabel.text     = [[NSUserDefaults standardUserDefaults] objectForKey:
                               [NSString stringWithFormat:@"gate%@", park.gateID]];
    
    _parkTopLabel.text      = [[NSUserDefaults standardUserDefaults] objectForKey:
                               [NSString stringWithFormat:@"top%@", park.parkTopID]];
    
    _parkTypeLabel.text     = [[NSUserDefaults standardUserDefaults] objectForKey:
                               [NSString stringWithFormat:@"type%@", park.parkTypeID]];
    

    NSString *str = [NSString stringWithFormat:@"%@", _parkingSpotToPass.favorit];
    
    if ([str isEqualToString:@"0"])
    {
        _parkFavoriteLabel.text = @"X";
    }
    
    else _parkFavoriteLabel.text = @"V";
    
    
    // ****** parse slots test ***********
    
    
    
    NSString *timeString                 = [[NSString alloc] init];
    
    NSMutableDictionary *timesDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *daysArray = [[NSArray alloc] initWithObjects:@"א",@"ב",@"ג",@"ד",@"ה",@"ו",@"ש", nil];
    
    NSMutableArray *timesArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i < [[slots allKeys] count]; i++)
        
    {
        timesDictionary = [slots objectForKey:[[slots allKeys] objectAtIndex:i]];
        
        NSString *day       = [NSString stringWithFormat:@"%@",
                                [daysArray objectAtIndex:[[timesDictionary objectForKey:@"day"] intValue]]];
        
        NSArray *endArray   = [[timesDictionary objectForKey:kEndTime]   componentsSeparatedByString:@":"];
        
        NSArray *startArray = [[timesDictionary objectForKey:kStartTime] componentsSeparatedByString:@":"];
        
        NSString *endTime   = [NSString stringWithFormat:@"%@:%@", endArray[0], endArray[1]];
        
        NSString *startTime = [NSString stringWithFormat:@"%@:%@", startArray[0], startArray[1]];
        
        timeString = [NSString stringWithFormat:@"%@' %@-%@",day,endTime,startTime];
        
        [timesArray addObject:timeString];

    }
    
    NSArray *result = [timesArray sortedArrayUsingSelector:@selector(compare:)];
    
    int i=0;
    
    if ([slots objectForKey:@"0"] != NULL)
        
    {
        _sundayLabel.text = [result objectAtIndex:i];
        i++;
    }
    
    if ([slots objectForKey:@"1"] != NULL)
        
    {
        _mondayLabel.text = [result objectAtIndex:i];
        i++;
    }

    
    if ([slots objectForKey:@"2"] != NULL)
        
    {
        _tuesdayLabel.text = [result objectAtIndex:i];
        i++;
    }
    
    if ([slots objectForKey:@"3"] != NULL)
        
    {
        _wednesdayLabel.text = [result objectAtIndex:i];
        i++;
    }
    
    if ([slots objectForKey:@"4"] != NULL)
        
    {
        _thursdayLabel.text = [result objectAtIndex:i];
        i++;
    }
    
    if ([slots objectForKey:@"5"] != NULL)
        
    {
        _fridayLabel.text = [result objectAtIndex:i];
        i++;
    }
    
    if ([slots objectForKey:@"6"] != NULL)
        
    {
        _saturdayLabel.text = [result objectAtIndex:i];
        i++;
    }
  
}


#pragma mark - UI Picker View Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    [pickerView setTransform:CGAffineTransformMakeScale(0.5,0.3)];
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) return [_hours count];
    else return [_minutes count];
}

#pragma mark - UI Picker View Delegate Methods

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSString *title = [_hours objectAtIndex:row];
        //UIFont   *font  = [UIFont fontWithName:@"Alef-Bold" size:17.0];
        UIFont   *font  = [UIFont systemFontOfSize:50];
        UIColor *color  = [UIColor blueColor];
        NSMutableDictionary *attrsDictionary = [[NSMutableDictionary alloc] init];
        [attrsDictionary setObject:font  forKey:NSFontAttributeName];
        [attrsDictionary setObject:color forKey:NSForegroundColorAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        
        return attrString;
    }
    else
    {
        NSString *title = [_minutes objectAtIndex:row];
        //UIFont   *font  = [UIFont fontWithName:@"Alef-Bold" size:17.0];
        UIFont   *font  = [UIFont systemFontOfSize:50];
        UIColor *color  = [UIColor blueColor];
        NSMutableDictionary *attrsDictionary = [[NSMutableDictionary alloc] init];
        [attrsDictionary setObject:font  forKey:NSFontAttributeName];
        [attrsDictionary setObject:color forKey:NSForegroundColorAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        
        return attrString;
    }
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) hour = [_hours objectAtIndex:row];
    else minute = [_minutes objectAtIndex:row];
}





























@end
