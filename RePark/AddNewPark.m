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
    //NSMutableDictionary     *slotsIndex;
    NSMutableDictionary     *slotsIndexFromDic;
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

@property (strong, nonatomic) IBOutlet UIButton *addParkImageLabel;



@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic)   NSMutableDictionary *slotsIndex;



- (IBAction)pickerChooseButton:(id)sender;


- (IBAction)chooseDayButton:(id)sender;

- (IBAction)chooseStartHourButton:(id)sender;

- (IBAction)chooseEndHourButton:(id)sender;

- (IBAction)addSlotButton:(id)sender;


- (IBAction)getSizeButton:(id)sender;

- (IBAction)getTopButton:(id)sender;

- (IBAction)getGateButton:(id)sender;

- (IBAction)getTypeButton:(id)sender;

- (IBAction)addParkImageButton:(id)sender;


- (IBAction)cancelButton:(id)sender;

- (IBAction)okButton:(id)sender;


@end



@implementation AddNewPark

@synthesize mainView, slotsIndex;



- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    slotsIndex = [[NSMutableDictionary alloc] init];
    
    [self initialRelevantObjects];
    
    [self setViewsOnScreen];
    
    
    

}

- (void) setViewsOnScreen
{

    NSLog(@"\n ** set views on screen...");

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
    
    
    
    
    
    
    /*
     
     [parametersDictionary setObject:lat                           forKey:kLatitude];
     [parametersDictionary setObject:lng                           forKey:kLongtitude];
     [parametersDictionary setObject:_parkAddressLabel.text        forKey:kAddressID];
     
     [parametersDictionary setObject:@"0"                          forKey:kPricePerDay];
     [parametersDictionary setObject:@"5"                          forKey:kPricePerHour];
     [parametersDictionary setObject:_pricePerDay.text             forKey:kParkComments];
     [parametersDictionary setObject:slotsIndex                    forKey:@"parkSlots"];
     
     [parametersDictionary setObject:selectedImage                 forKey:@"parkImage"];
     [parametersDictionary setObject:@"Y"                          forKey:@"buildingImage"];
     [parametersDictionary setObject:@"0536244266"                 forKey:@"gatePhone"];
     
     
     */
    
    if (_dictionary)
        
    {
        
        NSLog(@"\n dictionary isnt nil...");
        
        if ([_dictionary objectForKey:@"editTitle"])
        {
            _mainTitle.text = [_dictionary objectForKey:@"editTitle"];
        }
        
        if ([_dictionary objectForKey:@"parkSlots"])
        {
            slotsIndex = [_dictionary objectForKey:@"parkSlots"];
            
            NSArray *arr = [[NSArray alloc] initWithArray:[appDelegate.dataBase objectForKey:@"days"]];
            
            for (int i = 0; i< [[slotsIndex allKeys] count]; i++)
            {
                
                NSDictionary *slotTime = [[NSDictionary alloc] initWithDictionary:[slotsIndex objectForKey:[NSString stringWithFormat:@"%d", i]]];

                NSString *dayNumber = [NSString stringWithFormat:@"%@", [slotTime objectForKey:@"day"]];

                NSString *dayName = [arr objectAtIndex:[dayNumber intValue]];

                NSString *slotString = [NSString stringWithFormat:@"%@ , %@ - %@",
                                        dayName,
                                        [slotTime objectForKey:kStartTime],
                                        [slotTime objectForKey:kEndTime]];
                
                [[slotsArray objectAtIndex:i] setText:slotString];
                
                [[slotsArray objectAtIndex:i] setHidden:NO];
                
                slotsCounter = [[_dictionary objectForKey:@"slotsCounter"] intValue];
                
                
            }
        }
        
        if ([_dictionary objectForKey:kAddressID])
        {

            _parkAddressLabel.text = [_dictionary objectForKey:kAddressID];
            
            addressGeo.latitude    = [[_dictionary objectForKey:kLatitude]   floatValue];
            
            addressGeo.longitude    = [[_dictionary objectForKey:kLongtitude] floatValue];
            
        }
        
        if ([_dictionary objectForKey:kParkComments])
        {
            _pricePerDay.text = [_dictionary objectForKey:kParkComments];
            [parametersDictionary setObject:_pricePerDay.text forKey:kParkComments];
        }
        
        if ([_dictionary objectForKey:kParkTypeID])
        {
            [parametersDictionary setObject:[_dictionary objectForKey:kParkTypeID] forKey:kParkTypeID];
            NSString *str = [_dictionary objectForKey:kParkTypeID];
            _getTypeTitle.titleLabel.text =
            [[appDelegate.dataBase objectForKey:kParkTypeID] objectAtIndex:[str intValue]];
        }
        
        if ([_dictionary objectForKey:kParkTopID])
        {
            [parametersDictionary setObject:[_dictionary objectForKey:kParkTopID] forKey:kParkTopID];
            NSString *str = [_dictionary objectForKey:kParkTopID];
            _getTopTitle.titleLabel.text =
            [[appDelegate.dataBase objectForKey:kParkTopID] objectAtIndex:[str intValue]];
        }
        
        if ([_dictionary objectForKey:kGateID])
        {
            [parametersDictionary setObject:[_dictionary objectForKey:kGateID] forKey:kGateID];
            NSString *str = [_dictionary objectForKey:kGateID];
            _getGateTitle.titleLabel.text =
            [[appDelegate.dataBase objectForKey:kGateID] objectAtIndex:[str intValue]];
        }
        
        if ([_dictionary objectForKey:kSizeID])
        {
            [parametersDictionary setObject:[_dictionary objectForKey:kSizeID] forKey:kSizeID];
            NSString *str = [_dictionary objectForKey:kSizeID];
            _getSizeTitle.titleLabel.text =
            [[appDelegate.dataBase objectForKey:kSizeID] objectAtIndex:[str intValue]];
        }
        
        _imageView.image      = [_dictionary objectForKey:@"image"];
        
        // add image to parametersDictionary...
    }
}

- (void) initialRelevantObjects

{
    
    _parkAddressLabel.delegate = self;
    
    _pricePerDay.delegate      = self;
    
    _pricePerHour. delegate    = self;
    
    appDelegate  = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    slotsCounter = 0;
    
    slotsArray   = [[NSMutableArray alloc] initWithObjects: _day1SlotLabel,
                                                            _day2SlotLabel,
                                                            _day3SlotLabel,
                                                            _day4SlotLabel,
                                                            _day5SlotLabel,
                                                            _day6SlotLabel,
                                                            _day7SlotLabel,nil];
    
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
    [_addParkImageLabel setHidden:NO];
    [_imageView         setHidden:NO];

    
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
    
    [_addParkImageLabel  setHidden:YES];
    
    [_imageView          setHidden:YES];
   
    
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
    
    [_addParkImageLabel setHidden:YES];
    
    [_imageView         setHidden:YES];
    
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
    
    [_addParkImageLabel setHidden:YES];
    
    [_imageView         setHidden:YES];
    
    
}




- (IBAction)addSlotButton:(id)sender

{
    // set slots dictionary for server request
    
    NSString *index = [NSString stringWithFormat:@"%d", slotsCounter];
    
    NSArray *arr = [[NSArray alloc] initWithArray:[appDelegate.dataBase objectForKey:@"days"]];
    
    NSString *dayNumber = [NSString stringWithFormat:@"%lu",
                           (unsigned long)[arr indexOfObject:_chooseDayTitle.titleLabel.text]];
    
    NSMutableDictionary *slotsTimes = [[NSMutableDictionary alloc] init];
    
    [slotsTimes setObject:dayNumber                         forKey:@"day"];
    [slotsTimes setObject:_chooseStartTitle.titleLabel.text forKey:@"startTime"];
    [slotsTimes setObject:_chooseEndTitle.titleLabel.text   forKey:@"endTime"];
    
    [slotsIndex setObject:slotsTimes forKey:index];
    
    slotsTimes = nil;
    
    
    NSLog(@"\n slots arrrrre: %@", slotsIndex);
    
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








- (IBAction)addParkImageButton:(id)sender

{
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"שים לב !"
                                                 message:@"האם תרצלה לצלם תמונה חדשה? \n או לבחור מתוך אלבום התמונות שלך?"
                                             cancelTitle:@"צלם תמונה חדשה"
                                             otherTitles:@[@"בחר מתוך האלבום"]
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0)
                                                  {
                                                      [self takePhoto];
                                                  }
                                                  else if (buttonIndex == 1)
                                                  {
                                                      [self selectPhoto];
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
    
    NSLog(@"** json; %@", jsonString);
    
    
    // parmaeters for new park
    
    
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSString *lat = [NSString stringWithFormat:@"%f", addressGeo.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", addressGeo.longitude];
    
    [parametersDictionary setObject:accessToken                   forKey:kAccessToken];
    [parametersDictionary setObject:kAddPark                      forKey:kService];
    
    [parametersDictionary setObject:lat                           forKey:kLatitude];
    [parametersDictionary setObject:lng                           forKey:kLongtitude];
    [parametersDictionary setObject:_parkAddressLabel.text        forKey:kAddressID];
    
    [parametersDictionary setObject:@"0"                          forKey:kPricePerDay];
    [parametersDictionary setObject:@"5"                          forKey:kPricePerHour];
    [parametersDictionary setObject:_pricePerDay.text             forKey:kParkComments];
    [parametersDictionary setObject:jsonString                    forKey:@"parkSlots"];
    
    //[parametersDictionary setObject:@"X"                          forKey:@"parkImage"];
    [parametersDictionary setObject:@"Y"                          forKey:@"buildingImage"];
    [parametersDictionary setObject:@"0536244266"                 forKey:@"gatePhone"];
    
    NSLog(@"paremters; %@", parametersDictionary);
    

    
    
    
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.5);

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
                                              initWithBaseURL:[NSURL URLWithString:kServerAdrress]];
    
    AFHTTPRequestOperation *op =[manager POST:@""
                                   parameters:parametersDictionary
                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                     //do not put image inside parameters dictionary as I did, but append it!
                                     [formData appendPartWithFileData:imageData
                                                                 name:@"parkImage"
                                                             fileName:@"photo.jpg"
                                                             mimeType:@"image/jpeg"];
                                 }
                                 
                                      success:^(AFHTTPRequestOperation *operation, id responseObject)
                                 {
                                     NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                     
                                     PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה בהצלחה !"
                                                                                 message:@"החניה תתווסף מיד לרשימת החניות"
                                                                             cancelTitle:@"אישור"
                                                                              completion:^(BOOL cancelled, NSInteger buttonIndex)
                                                          {
                                                              
                                                          }];
                                     [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
                                     
                                     
                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                 }
                                 
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error)
                                 {
                                     NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                     
                                     NSString *message = [NSString stringWithFormat:@"לצערנו לא היתה אפשרות להוסיף את החניה. \n xסיבת השגיאה היא: \n %@", operation.responseString];
                                     PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                                                 message:message
                                                                             cancelTitle:@"אישור"
                                                                              completion:^(BOOL cancelled, NSInteger buttonIndex)
                                                          {
                                                              
                                                          }];
                                     [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
                                     
                                     
                                 }];
    
    [op start];

    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    [manager POST:kServerAdrress parameters:parametersDictionary success:^(AFHTTPRequestOperation *operation, id responseObject)
//     
//     {
//         
//         [self getDataFromResponse:responseObject];
//         
//     }
//     
//          failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     
//     {
//         
//         NSLog(@"Error: %@", error);
//         
//         // ****************************************
//         // * call alert to show error             *
//         // ****************************************
//         
//     }];
    
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
            NSString *message = [NSString stringWithFormat:@"לצערנו לא היתה אפשרות להוסיף את החניה. \n xסיבת השגיאה היא: \n %@", [dataDictionary objectForKey:@"message"]];
            
            PXAlertView *alert =[PXAlertView showAlertWithTitle:@"בקשתך התקבלה במערכת."
                                                        message:message
                                                    cancelTitle:@"אישור"
                                                     completion:^(BOOL cancelled, NSInteger buttonIndex)
                                 {
                                     
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

#pragma mark - open camera roll Methods

- (void)takePhoto
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void) selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSString *lat = [NSString stringWithFormat:@"%f", addressGeo.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f", addressGeo.longitude];

    [parametersDictionary setObject:lat                           forKey:kLatitude];
    [parametersDictionary setObject:lng                           forKey:kLongtitude];
    [parametersDictionary setObject:_parkAddressLabel.text        forKey:kAddressID];
    
    [parametersDictionary setObject:@"0"                          forKey:kPricePerDay];
    [parametersDictionary setObject:@"5"                          forKey:kPricePerHour];
    [parametersDictionary setObject:_pricePerDay.text             forKey:kParkComments];
    [parametersDictionary setObject:slotsIndex                    forKey:@"parkSlots"];
    
    [parametersDictionary setObject:
     [NSString stringWithFormat:@"%d",slotsCounter]               forKey:@"slotsCounter"];
    
    [parametersDictionary setObject:selectedImage                 forKey:@"image"];
    [parametersDictionary setObject:@"Y"                          forKey:@"buildingImage"];
    [parametersDictionary setObject:@"0536244266"                 forKey:@"gatePhone"];

    [self.delegate popUp:self withParkData:parametersDictionary];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
















@end
