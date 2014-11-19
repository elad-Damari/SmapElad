//
//  ParkDetailsForOrder.m
//  RePark
//
//  Created by Elad Damari on 11/18/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkDetailsForOrder.h"
#import "UIViewController+MJPopupViewController.h"
#import "Park.h"

@interface ParkDetailsForOrder ()
{
    NSDateFormatter *format;
    int flag;
    NSMutableDictionary     *parametersDictionary;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *orderPickerView;


@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *userDidChooseLabel;


@property (strong, nonatomic)   NSDate      *dateChosen;

@property (strong, nonatomic)   NSString    *dateChosenString;


- (IBAction)chooseButton:  (id)sender;

- (IBAction)dateButton:    (id)sender;

- (IBAction)startButton:   (id)sender;

- (IBAction)endButton:     (id)sender;

- (IBAction)cancelButton:  (id)sender;

- (IBAction)continueButton:(id)sender;



@end

@implementation ParkDetailsForOrder

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setViewsOnScreen];

}


#pragma mark - Action Methods


- (IBAction)dateButton:(id)sender

{
    flag = 1 ;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [_orderPickerView setCalendar:calender];
    
    [_orderPickerView setDatePickerMode:UIDatePickerModeDate];
    
    [_orderPickerView setHidden:NO];
    
    [_userDidChooseLabel setHidden:NO];
    
}


- (IBAction)startButton:(id)sender

{
    
    flag = 2;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [_orderPickerView setCalendar:calender];
    
    [_orderPickerView setDatePickerMode:UIDatePickerModeTime];
    
    [_orderPickerView setHidden:NO];
    
    [_userDidChooseLabel setHidden:NO];
    
}


- (IBAction)endButton:(id)sender

{
    
    flag = 3;
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [_orderPickerView setCalendar:calender];
   
    [_orderPickerView setDatePickerMode:UIDatePickerModeTime];
   
    [_orderPickerView setHidden:NO];
    
    [_userDidChooseLabel setHidden:NO];
    
}



- (IBAction)cancelButton:(id)sender
{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}



- (IBAction)continueButton:(id)sender
{
    
    [self.delegate popUp:self clickedParkReservation:_parkingSpotToPass
                withDate:_dateLabel.text
               startTime:_startTimeLabel.text
              andEndTime:_endTimeLabel.text];

}



- (IBAction)chooseButton:(id)sender

{
    
    if (flag == 1)
        
    {
        
        format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"dd.MM.yyyy"];
        
        _dateChosen                = [_orderPickerView date];
        
        _dateChosenString          = [format stringFromDate:_dateChosen];
        
        _dateLabel.text            = _dateChosenString;
        
        _orderPickerView.hidden    = YES;
        
        _userDidChooseLabel.hidden = YES;
        
    }
    
    
    else if (flag == 2)
        
    {
        
        format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"hh:mm"];
        
        _dateChosen                = [_orderPickerView date];
        
        _dateChosenString          = [format stringFromDate:_dateChosen];
        
        _startTimeLabel.text       = _dateChosenString;
        
        _orderPickerView.hidden    = YES;
        
        _userDidChooseLabel.hidden = YES;

    }
    
    
    else if (flag == 3)
        
    {
        
        format = [[NSDateFormatter alloc] init];
        
        [format setDateFormat:@"hh:mm"];
        
        _dateChosen                = [_orderPickerView date];
        
        _dateChosenString          = [format stringFromDate:_dateChosen];
        
        _endTimeLabel.text         = _dateChosenString;
        
        _orderPickerView.hidden    = YES;
        
        _userDidChooseLabel.hidden = YES;
        
    }
    
}




#pragma mark - Private Methods

- (void) setViewsOnScreen

{
    
    [_orderPickerView    setHidden:YES];
    
    [_userDidChooseLabel setHidden:YES];
    
}











@end
