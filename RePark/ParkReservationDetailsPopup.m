//
//  ParkReservationDetailsPopup.m
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkReservationDetailsPopup.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"

@interface ParkReservationDetailsPopup ()



@property (weak, nonatomic) IBOutlet UILabel *parkIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *parkPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *reservationPrice;

@property (weak, nonatomic) IBOutlet UILabel *chooseCarLabel;

@property (strong, nonatomic)          NSArray *cars;

@property (strong, nonatomic)          NSString *carChosen;


- (IBAction)cancelButton:(id)sender;

- (IBAction)orderButton:(id)sender;

@end



@implementation ParkReservationDetailsPopup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSLog(@"\n data passed: \n park: %@ \n date: %@ \n start: %@ \n end: %@",
          _parkDetails, _date, _startTime, _endTime);
    
    _carIdPickerView = [[UIPickerView alloc] init];
    _carIdPickerView.hidden = YES;
    _cars            = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"654321",@"987654", nil ];
    _carChosen = [_cars objectAtIndex:0];
    [self setViewsOnScreen];

}

- (void) viewWillAppear:(BOOL)animated
{
    _carIdPickerView.hidden = YES;
}

- (IBAction)chooseCarButton:(id)sender

{
    
    self.carIdPickerView.hidden = NO;
    _chooseCarLabel.hidden = YES;

}

- (IBAction)cancelButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

- (IBAction)orderButton:(id)sender

{
    
    NSDictionary *parameters = [self getParametersForOrderPark:_parkDetails.parkID];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kServerAdrress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         [self getDataFromResponse:responseObject];
         
         //NSLog(@"response from details  is: %@", responseObject);
         
         
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"\n ***** Error: %@", error);
         
     }];

    
    
    
    
    
    
}

- (void) getDataFromResponse: (NSDictionary *) dataDictionary

{
    
    if (dataDictionary)
        
    {
        NSLog(@"dataDictionary: %@", dataDictionary);
        
        NSString *status = [dataDictionary objectForKey:@"status"];
        
        NSLog(@"status: %@", status);
        
        int price = [_parkPriceLabel.text intValue] + 5 ;
        
        NSString *alertMessage = [NSString stringWithFormat:@"תאריך: %@ \n התחלה: %@ \n סיום: %@ \n מחיר: %d ש''ח", _dateLabel.text, _startTimeLabel.text  , _endTimeLabel.text , price ];
        
        if ([status isEqualToString:@"Success"])
        {
            PXAlertView *alert =[PXAlertView showAlertWithTitle:@"הזמנתך אושרה !"
                                                        message:alertMessage
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
        
        else
            
        {
            
            
            PXAlertView *alert =[PXAlertView showAlertWithTitle:@"הזמנתך לא אושרה !"
                                                        message:@"לצערנו החניה כבר תפוסה  \n  תוכל לנסות לחפש חניה נוספת בתפריט הראשי"
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
    
}


- (NSDictionary *) getParametersForOrderPark: (NSString *) parkId

{
    
    NSString *accessToken    = [NSString stringWithFormat:@"%@",
                                [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    [dic setObject:accessToken           forKey:kAccessToken];
    
    [dic setObject:kOrderReservation     forKey:kService];
    
    [dic setObject:parkId                forKey:kParkID];
    
    [dic setObject:_carChosen            forKey:kCarID];
    
    [dic setObject:_date                 forKey:@"date"];
    
    [dic setObject:_startTime            forKey:@"startTime"];
    
    [dic setObject:_endTime              forKey:@"endTime"];
    
    return dic;
    
}



#pragma mark - UI Picker View Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    [pickerView setTransform:CGAffineTransformMakeScale(0.8,0.8)];
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_cars count];
}

#pragma mark - UI Picker View Delegate Methods

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    NSString *title = [_cars objectAtIndex:row];
    //UIFont   *font  = [UIFont fontWithName:@"Alef-Bold" size:17.0];
    UIFont   *font  = [UIFont systemFontOfSize:50];
    UIColor *color  = [UIColor blueColor];
    NSMutableDictionary *attrsDictionary = [[NSMutableDictionary alloc] init];
    [attrsDictionary setObject:font  forKey:NSFontAttributeName];
    [attrsDictionary setObject:color forKey:NSForegroundColorAttributeName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        
    return attrString;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@" car: %@", [_cars objectAtIndex:row]);
    _carChosen = [_cars objectAtIndex:row];
}


- (void) setViewsOnScreen

{
    
    [self calculatParkPrice];
    
    
    _parkIdLabel.text       = _parkDetails.parkID;
    
    _dateLabel.text         = _date;
    
    _startTimeLabel.text    = _startTime;
    
    _endTimeLabel.text      = _endTime;
    
    _addressLabel.text      = _parkDetails.addressID;
    
    _reservationPrice.text  = @"5";
    
    _carIdPickerView.hidden = YES;
    
    _chooseCarLabel.hidden  = YES;
    

    
    
}

- (void) calculatParkPrice
{
    
    int startHours, startMinutes, endHours, endMinutes,  resultHours,resultMinutes;
    
    NSArray *startArray = [_startTime componentsSeparatedByString:@":"];
    
    NSArray *endArray   = [_endTime   componentsSeparatedByString:@":"];
    
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
    
    
    
    int pricePerHour           = [_parkDetails.pricePerHour intValue];
    
    float pricePerMinute         = pricePerHour/60;
    
    
    float totalPricePerHours   = resultHours   * pricePerHour;
    
    float totalPricePerMinutes = resultMinutes * pricePerMinute;
    
    float finallPrice = totalPricePerHours + totalPricePerMinutes;
    
    int finalllll = finallPrice;
    
    _parkPriceLabel.text     = [NSString stringWithFormat:@"%d", finalllll];
    
}








@end
