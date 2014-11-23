//
//  AddNewPark.m
//  RePark
//
//  Created by Elad Damari on 11/19/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "AddNewPark.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"

@interface AddNewPark ()
<CLLocationManagerDelegate>
{
    AppDelegate     *appDelegate;
    
    CLLocation              *userLocation;
    CLLocationManager       *locationManager;
    CLGeocoder              *geocoder;
    CLPlacemark             *placemark;
    CLLocationCoordinate2D  addressGeo;
    
    NSCalendar              *calender;
    NSDateFormatter         *format;
    NSDate                  *dt;
    
    NSMutableArray          *slotsArray;
    NSMutableDictionary     *slotsIndex;
    NSMutableDictionary     *slotsTimes;
    NSMutableDictionary     *parametersDictionary;
    NSString                *chosenItem;
    
    CGPoint                 originalCenter;
    
    BOOL                    viewMoved;
    int                     flag, slotsCounter;
}

@property (strong, nonatomic) IBOutlet     UIView *mainView;



@property (weak, nonatomic) IBOutlet UITextField  *parkAddressLabel;

@property (weak, nonatomic) IBOutlet UITextField  *pricePerHour;

@property (weak, nonatomic) IBOutlet UITextField  *pricePerDay;


@property (strong, nonatomic) IBOutlet UIDatePicker *timesPickerView;

@property (strong, nonatomic) IBOutlet UIButton     *pickerChooseLabel;


@property (weak, nonatomic) IBOutlet UILabel      *day1SlotLabel;

@property (weak, nonatomic) IBOutlet UILabel      *day2SlotLabel;

@property (weak, nonatomic) IBOutlet UILabel      *day3SlotLabel;

@property (weak, nonatomic) IBOutlet UILabel      *day4SlotLabel;

@property (weak, nonatomic) IBOutlet UILabel      *day5SlotLabel;

@property (weak, nonatomic) IBOutlet UILabel      *day6SlotLabel;

@property (weak, nonatomic) IBOutlet UILabel      *day7SlotLabel;


@property (weak, nonatomic) IBOutlet UIButton *chooseDayTitle;

@property (weak, nonatomic) IBOutlet UIButton *chooseStartTitle;

@property (weak, nonatomic) IBOutlet UIButton *chooseEndTitle;

@property (weak, nonatomic) IBOutlet UIButton *addSlotTitle;



@property (strong, nonatomic) IBOutlet UIButton *getSizeTitle;

@property (strong, nonatomic) IBOutlet UIButton *getTopTitle;

@property (strong, nonatomic) IBOutlet UIButton *getGateTitle;

@property (strong, nonatomic) IBOutlet UIButton *getTypeTitle;




- (IBAction)pickerChooseButton:(id)sender;


- (IBAction)chooseDayButton:(id)sender;

- (IBAction)chooseStartHourButton:(id)sender;

- (IBAction)chooseEndHourButton:(id)sender;

- (IBAction)addSlotButton:(id)sender;


- (IBAction)getSizeButton:(id)sender;

- (IBAction)getTopButton:(id)sender;

- (IBAction)getGateButton:(id)sender;

- (IBAction)getTypeButton:(id)sender;


- (IBAction)cancelButton:(id)sender;

- (IBAction)okButton:(id)sender;


@end



@implementation AddNewPark

@synthesize mainView;



- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    [self setViewsOnScreen];
    
    [self initialRelevantObjects];
    
    
    

}

- (void) setViewsOnScreen
{
    
    [_timesPickerView setTransform:CGAffineTransformMakeScale(1.0,0.7)];
    
    [_timesPickerView setBackgroundColor:[UIColor whiteColor]];
    
    
    [_timesPickerView   setHidden:YES];
    
    [_pickerChooseLabel setHidden:YES];
    
    [_day1SlotLabel     setHidden:YES];
    
    [_day2SlotLabel     setHidden:YES];
    
    [_day3SlotLabel     setHidden:YES];
    
    [_day4SlotLabel     setHidden:YES];
    
    [_day5SlotLabel     setHidden:YES];
    
    [_day6SlotLabel     setHidden:YES];
    
    [_day7SlotLabel     setHidden:YES];
    
    
    _chooseDayTitle.titleLabel.textColor   = [UIColor redColor];
    
    _chooseStartTitle.titleLabel.textColor = [UIColor redColor];
    
    _chooseEndTitle.titleLabel.textColor   = [UIColor redColor];
    
    
    _getSizeTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _getGateTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _getTopTitle.titleLabel.textAlignment  = NSTextAlignmentCenter;
    
    _getTypeTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    // at the moment, client doesn't want user to enter price per day & price per hour must be 5 nis.

    _pricePerHour.enabled = NO;
}

- (void) initialRelevantObjects

{
    
    _parkAddressLabel.delegate = self;
    
    _pricePerDay.delegate      = self;
    
    _pricePerHour. delegate    = self;
    
    appDelegate  = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    slotsCounter = 0;
    
    slotsArray   = [[NSMutableArray alloc] initWithObjects:_day1SlotLabel,
                    _day2SlotLabel,
                    _day3SlotLabel,
                    _day4SlotLabel,
                    _day5SlotLabel,
                    _day6SlotLabel,
                    _day7SlotLabel,nil];
    
    slotsIndex = [[NSMutableDictionary alloc] init];
    
    slotsTimes = [[NSMutableDictionary alloc] init];
    
    parametersDictionary = [[NSMutableDictionary alloc] init];
    
}



- (IBAction)pickerChooseButton:(id)sender
{
    [_timesPickerView   setHidden:YES];
    [_pickerChooseLabel setHidden:YES];
    
    [_getGateTitle      setHidden:NO];
    [_getSizeTitle      setHidden:NO];
    [_getTopTitle       setHidden:NO];
    [_getTypeTitle      setHidden:NO];

    
    if (flag == 1)
    {

        dt = _timesPickerView.date;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
        NSDateComponents *components = [calender components:units fromDate:dt];
        NSInteger year = [components year];
        NSInteger day  = [components day];
        NSDateFormatter *weekDay = [[NSDateFormatter alloc]init];
        [weekDay setDateFormat:@"EEEE"];
        NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
        [calMonth setDateFormat:@"MM"];
        
        chosenItem = [NSString stringWithFormat:@"%@, %li-%@-%li",
                      [weekDay stringFromDate:dt],
                      (long)day,
                      [calMonth stringFromDate:dt],
                      (long)year];
        
        NSArray *onlyDayName   = [chosenItem componentsSeparatedByString:@" "];
        chosenItem = [onlyDayName[1] substringToIndex:[onlyDayName[1] length]-1];
        
        _chooseDayTitle.titleLabel.text      = chosenItem;
        _chooseDayTitle.titleLabel.textColor = [UIColor greenColor];

    }
    
    else if (flag == 2)
    {
        
        format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"hh:mm"];
        
        dt                                = [_timesPickerView date];
        
        chosenItem                        = [format stringFromDate:dt];
        
        NSLog(@" chosen: %@", chosenItem);
        
        _chooseStartTitle.titleLabel.text = chosenItem;
        
        _chooseStartTitle.titleLabel.textColor = [UIColor greenColor];
        
        _timesPickerView.hidden           = YES;
        
        _pickerChooseLabel.hidden         = YES;
        
    }
    
    else if (flag == 3)
    {
        
        format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"hh:mm"];
        
        dt                                = [_timesPickerView date];
        
        chosenItem                        = [format stringFromDate:dt];
        
        _chooseEndTitle.titleLabel.text = chosenItem;
        
        _chooseEndTitle.titleLabel.textColor = [UIColor greenColor];
        
        _timesPickerView.hidden           = YES;
        
        _pickerChooseLabel.hidden         = YES;
        
    }
    
    
}



- (IBAction)chooseDayButton:(id)sender
{
    
    flag =1;
    
    calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [_timesPickerView    setCalendar:calender];

    [_timesPickerView    setDatePickerMode:UIDatePickerModeDate];
    
    [_timesPickerView    setHidden:NO];
    
    [_pickerChooseLabel  setHidden:NO];
    
    [_getGateTitle       setHidden:YES];
    
    [_getSizeTitle       setHidden:YES];
    
    [_getTopTitle        setHidden:YES];
    
    [_getTypeTitle       setHidden:YES];
   
    
}

- (IBAction)chooseStartHourButton:(id)sender

{
    
    flag = 2;
    
    calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [_timesPickerView   setCalendar:calender];
    
    [_timesPickerView   setDatePickerMode:UIDatePickerModeTime];
    
    [_timesPickerView   setHidden:NO];
    
    [_pickerChooseLabel setHidden:NO];
    
    [_getGateTitle      setHidden:YES];
    
    [_getSizeTitle      setHidden:YES];
    
    [_getTopTitle       setHidden:YES];
    
    [_getTypeTitle      setHidden:YES];
    
}


- (IBAction)chooseEndHourButton:(id)sender

{
    
    flag = 3;
    
    calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [_timesPickerView   setCalendar:calender];
    
    [_timesPickerView   setDatePickerMode:UIDatePickerModeTime];
    
    [_timesPickerView   setHidden:NO];
    
    [_pickerChooseLabel setHidden:NO];
    
    [_getGateTitle      setHidden:YES];
    
    [_getSizeTitle      setHidden:YES];
    
    [_getTopTitle       setHidden:YES];
    
    [_getTypeTitle      setHidden:YES];
    
    
}




- (IBAction)addSlotButton:(id)sender

{
    // set slots dictionary for server request
    
    NSString *index = [NSString stringWithFormat:@"%d", slotsCounter];
    NSString *dayNumber = [NSString stringWithFormat:@"%@", [[appDelegate.dataBase objectForKey:@"days"] objectForKey:_chooseDayTitle.titleLabel.text]];
    
    
    [slotsTimes setObject:dayNumber                         forKey:@"day"];
    [slotsTimes setObject:_chooseStartTitle.titleLabel.text forKey:@"startTime"];
    [slotsTimes setObject:_chooseEndTitle.titleLabel.text   forKey:@"endTime"];

    [slotsIndex setObject:slotsTimes forKey:index];
    
    NSLog(@"slots sre: %@", slotsIndex);
    
    // set views on screen

    NSString *slotString = [NSString stringWithFormat:@"%@ , %@ - %@",
                            _chooseDayTitle.titleLabel.text,
                            _chooseStartTitle.titleLabel.text,
                            _chooseEndTitle.titleLabel.text];
    
    [[slotsArray objectAtIndex:slotsCounter] setHidden:NO];
    [[slotsArray objectAtIndex:slotsCounter] setText:slotString];
    
    slotsCounter++;
    if (slotsCounter == 7)
    {
        _addSlotTitle.hidden = YES;
    }
    
    _chooseDayTitle.titleLabel.textColor   = [UIColor redColor];
    _chooseStartTitle.titleLabel.textColor = [UIColor redColor];
    _chooseEndTitle.titleLabel.textColor   = [UIColor redColor];
    
    _chooseDayTitle.titleLabel.text   = @"בחר יום";
    _chooseStartTitle.titleLabel.text = @"החל משעה";
    _chooseEndTitle.titleLabel.text   = @"עד שעה";
    
}


- (IBAction)getSizeButton:(id)sender

{
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"גודל החניה"
                                                 message:@"אנא בחר את גודל החניה"
                                             cancelTitle:
                                  [[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:1]
                                             otherTitles:@[
                                  [[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:2],
                                  [[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:3]]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                    if (buttonIndex == 0)
                                    {
                                        [_getSizeTitle setTitle:[[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:1] forState:UIControlStateNormal];
                                        [parametersDictionary setObject:@"1" forKey:kSizeID];
                                    }
                                    else if (buttonIndex == 1)
                                    {
                                        [_getSizeTitle setTitle:[[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:2] forState:UIControlStateNormal];
                                        [parametersDictionary setObject:@"2" forKey:kSizeID];
                                    }
                                    else if (buttonIndex == 2)
                                    {
                                        [_getSizeTitle setTitle:[[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:3] forState:UIControlStateNormal];
                                        [parametersDictionary setObject:@"3" forKey:kSizeID];
                                    }}];
    
    [alert setAllButtonsBackgroundColor:[UIColor grayColor]];
    
}

- (IBAction)getTopButton:(id)sender

{
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"מיקום החניה"
                                                 message:@"אנא בחר את מיקום החניה"
                                             cancelTitle:
                        [[appDelegate.dataBase objectForKey:kParkTopID] objectAtIndex:1]
                                             otherTitles:@[
                        [[appDelegate.dataBase objectForKey:kParkTopID] objectAtIndex:2]]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0)
                                                  {
                                                      [_getTopTitle setTitle:[[appDelegate.dataBase objectForKey:kParkTopID] objectAtIndex:1] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"1" forKey:kParkTopID];
                                                  }
                                                  
                                                  else if (buttonIndex == 1)
                                                  {
                                                      
                                                      [_getTopTitle setTitle:[[appDelegate.dataBase objectForKey:kParkTopID] objectAtIndex:2] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"2" forKey:kParkTopID];
                                                  }}];
    
    [alert setAllButtonsBackgroundColor:[UIColor grayColor]];
    
}


- (IBAction)getGateButton:(id)sender

{
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"סוג שער"
                                                 message:@"אנא בחר את סוג השער"
                                             cancelTitle:
                        [[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:1]
                                             otherTitles:@[
                        [[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:2],
                        [[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:3],
                        [[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:4]]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0)
                                                  {
                                                      [_getGateTitle setTitle:[[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:1] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"1" forKey:kGateID];
                                                  }
                                                  else if (buttonIndex == 1)
                                                  {
                                                      [_getGateTitle setTitle:[[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:2] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"2" forKey:kGateID];
                                                  }
                                                  else if (buttonIndex == 2)
                                                  {
                                                      [_getGateTitle setTitle:[[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:3] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"3" forKey:kGateID];
                                                  }
                                                  else if (buttonIndex == 3)
                                                  {
                                                      [_getGateTitle setTitle:[[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:4] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"4" forKey:kGateID];
                                                  }}];
    
    [alert setAllButtonsBackgroundColor:[UIColor grayColor]];
    
}

- (IBAction)getTypeButton:(id)sender

{
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"סוג החניה"
                                                 message:@"אנא בחר את סוג החניה"
                                             cancelTitle:
                        [[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:1]
                                             otherTitles:@[
                        [[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:2],
                        [[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:3]]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0)
                                                  {
                                                      [_getTypeTitle setTitle:[[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:1] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"1" forKey:kParkTypeID];
                                                  }
                                                  else if (buttonIndex == 1)
                                                  {
                                                      [_getTypeTitle setTitle:[[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:2] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"2" forKey:kParkTypeID];
                                                  }
                                                  else if (buttonIndex == 2)
                                                  {
                                                      [_getTypeTitle setTitle:[[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:3] forState:UIControlStateNormal];
                                                      [parametersDictionary setObject:@"3" forKey:kParkTypeID];
                                                  }}];
    
    [alert setAllButtonsBackgroundColor:[UIColor grayColor]];
    
    
}

- (IBAction)cancelButton:(id)sender
{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}

- (IBAction)okButton:(id)sender

{
    NSString *jsonString;
    NSError  *error;
    NSData   *jsonData = [NSJSONSerialization dataWithJSONObject:slotsIndex
                                                         options:0 // Pass 0 if you don't care about the readability of the generated string
                                                           error:&error];
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }
    else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"json; %@", parametersDictionary);
    
    
    // parmaeters for new park
    
    
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *lat = [NSString stringWithFormat:@"%f", addressGeo.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", addressGeo.longitude];
    
    [parametersDictionary setObject:accessToken                   forKey:kAccessToken];
    [parametersDictionary setObject:kAddPark                      forKey:kService];
    //[parametersDictionary setObject:_getSizeTitle.titleLabel.text forKey:kSizeID];
    //[parametersDictionary setObject:_getGateTitle.titleLabel.text forKey:kGateID];
    //[parametersDictionary setObject:_getTopTitle.titleLabel.text  forKey:kParkTopID];
    //[parametersDictionary setObject:_getTypeTitle.titleLabel.text forKey:kParkTypeID];
    
    [parametersDictionary setObject:lat                           forKey:kLatitude];
    [parametersDictionary setObject:lng                           forKey:kLongtitude];
    [parametersDictionary setObject:_parkAddressLabel.text        forKey:kAddressID];
    
    [parametersDictionary setObject:@"0"                          forKey:kPricePerDay];
    [parametersDictionary setObject:@"5"                          forKey:kPricePerHour];
    [parametersDictionary setObject:_pricePerDay.text             forKey:kParkComments];
    [parametersDictionary setObject:jsonString                    forKey:@"parkSlots"];
    
    [parametersDictionary setObject:@"X"                          forKey:@"parkImage"];
    [parametersDictionary setObject:@"Y"                          forKey:@"buildingImage"];
    [parametersDictionary setObject:@"0536244266"                 forKey:@"gatePhone"];
    
    NSLog(@"paremters; %@", parametersDictionary);
    

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kServerAdrress parameters:parametersDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
     
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

        

        
        NSString *status = [dataDictionary objectForKey:@"status"];
        
        NSLog(@" status & message: \n %@ \n %@",status,  [dataDictionary objectForKey:@"message"]);
        
        if ([status isEqualToString:@"Success"])
        {
            
            PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
                                                        message:@"החניה תתווסף מיד לרשימת החניות"
                                                    cancelTitle:@"אישור"
                                                     completion:^(BOOL cancelled, NSInteger buttonIndex)
                                 {
                                     
                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                     
                                 }];
            [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
            
        }
        
        else
            
        {
            
            PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה במערכת."
                                                        message:@"לצערנו, כרגע לא היתה אפשרות להוסיף את החניה."
                                                    cancelTitle:@"אישור"
                                                     completion:^(BOOL cancelled, NSInteger buttonIndex)
                                 {
                                     
                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                     
                                 }];
            [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
            
        }

     }
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
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

// In Case the text field is in lower screen,
// moves the view so the keyboard won't hide it.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint point = [textField.superview convertPoint:textField.frame.origin toView:nil];
    
    if (point.y > 320.0)
    {
        viewMoved = YES;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        originalCenter = CGPointMake(mainView.center.x, mainView.center.y);
        mainView.center = CGPointMake(originalCenter.x, originalCenter.y -160);
        [UIView commitAnimations];
    }
}


// In Case the text field is in lower screen,
// moves the view back to its place.
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (viewMoved == YES)
    {
        viewMoved = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        mainView.center = originalCenter;
        [UIView commitAnimations];
    }
    else // address textfield
    {
        NSLog(@"end editing...");
        
        addressGeo = [self geoCodeUsingAddress:_parkAddressLabel.text];
        
            //*********** location log **************
            //int radiusVal = [val.text intValue];
            NSLog(@"\n address geo lat = %f \n address geo lng = %f "
                 , addressGeo.latitude, addressGeo.longitude);
        
        if (addressGeo.latitude == 0 || addressGeo.longitude == 0)
        {
            
            PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב!"
                                                        message:@"הכתובת שהזנת שגויה. \n אנא הזן כתובת רלוונטית."
                                                    cancelTitle:@"אישור"
                                                     completion:^(BOOL cancelled, NSInteger buttonIndex)
                                 {
                                     if (cancelled)
                                     {
                                         NSLog(@"Simple Alert View cancelled");
                                     }
                                     else
                                     {
                                         NSLog(@"Simple Alert View dismissed, but not cancelled");
                                         
                                     }}];
            [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
            
        }
    }
    

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










@end
