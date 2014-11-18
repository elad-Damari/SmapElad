//
//  StartParkingPopUp.m
//  RePark
//
//  Created by Elad Damari on 11/11/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "StartParkingPopUp.h"
#import "Park.h"
#import "AFNetworking.h"
#import "UIViewController+MJPopupViewController.h"

@interface StartParkingPopUp ()


@property (weak, nonatomic) IBOutlet UILabel     *parkIdLabel;

@property (weak, nonatomic) IBOutlet UILabel     *carNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel     *addressIdLabel;

@property (weak, nonatomic) IBOutlet UILabel     *timeLeftLabel;

@property (weak, nonatomic) IBOutlet UILabel     *commentsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *parkingImage;

@property (weak, nonatomic) IBOutlet UIImageView *buidingImage;






- (IBAction)navigateButton:     (id)sender;

- (IBAction)extensionButton:    (id)sender;

- (IBAction)finishButton:       (id)sender;

- (IBAction)contactUsButton:    (id)sender;

- (IBAction)openGateButton:     (id)sender;

- (IBAction)closePopUpButton:   (id)sender;


@end

@implementation StartParkingPopUp

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    NSLog(@"_park.timeRemain %@", _park.timeRemain);
    
    [self setLabelsWithParkInfo];
    
    //[self canStartParkTimer];
    
}


#pragma mark - Action Methods

- (IBAction)navigateButton:(id)sender

{
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]])
    {                                                  
        NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",
                                                         [_park.latitude floatValue],
                                                         [_park.longtitude floatValue]];
        
        //32.239317, 34.997362 -> home location for test...
        
        NSLog(@" ********  %@, %@", _park.latitude, _park.longtitude);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
    else
        
    {
        
        // if waze not instelled, launch AppStore to install Waze.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id323229106"]];
    }
    
}

- (IBAction)extensionButton:(id)sender

{
    
    [self.delegate popUp:self clickedExtension:_park.parkID];
    
}

- (IBAction)contactUsButton:(id)sender

{

    [self.delegate popUp:self clickedSupport:@"data"];
    
}

- (IBAction)openGateButton:(id)sender

{

    [self.delegate popUp:self clickedGate:_park];
    
}

- (IBAction)closePopUpButton:(id)sender

{

    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}


- (IBAction)finishButton:(id)sender

{
    
     [self.delegate popUp:self clickedEnd:_park];
    
}

// set labels with park details info

- (void) setLabelsWithParkInfo

{
    // ********************************************
    // * get user default from registration level *
    // ********************************************
    
    _carNumberLabel.text = [[NSUserDefaults standardUserDefaults]
                            objectForKey:@"defaultCarId"];

    _addressIdLabel.text = _park.addressID;
    
    _parkIdLabel.text    = _park.parkID;
    
    _commentsLabel.text  = _park.parkComments;
    
    _timeLeftLabel.text  = _park.timeRemain;
    
    
    // get parking start time (current time)...
    
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh-mm"];
    NSString *timeResultString = [dateFormatter stringFromDate: currentTime];
    _park.startTime = timeResultString;
    
    
    // save park to user default as cuurent park...
    [[NSUserDefaults standardUserDefaults] setObject:_park.parkID       forKey:kParkID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.userID       forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.sizeID       forKey:kSizeID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.gateID       forKey:kGateID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.parkTopID    forKey:kParkTopID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.parkTypeID   forKey:kParkTypeID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.parkComments forKey:kParkComments];
    
    [[NSUserDefaults standardUserDefaults] setObject:_park.parkImagePath     forKey:kParkImagePath];
    [[NSUserDefaults standardUserDefaults] setObject:_park.buildingImagePath forKey:kBuildingImagePath];
    
    [[NSUserDefaults standardUserDefaults] setObject:_park.addressID    forKey:kAddressID];
    [[NSUserDefaults standardUserDefaults] setObject:_park.latitude     forKey:kLatitude];
    [[NSUserDefaults standardUserDefaults] setObject:_park.longtitude   forKey:kLongtitude];
    [[NSUserDefaults standardUserDefaults] setObject:_park.distance     forKey:kDistance];
    
    [[NSUserDefaults standardUserDefaults] setObject:_park.pricePerDay  forKey:kPricePerDay];
    [[NSUserDefaults standardUserDefaults] setObject:_park.pricePerHour forKey:kPricePerHour];
    
    [[NSUserDefaults standardUserDefaults] setObject:_park.startTime    forKey:kStartTime];
    [[NSUserDefaults standardUserDefaults] setObject:_park.endTime      forKey:kEndTime];
    [[NSUserDefaults standardUserDefaults] setObject:_park.timeRemain   forKey:kTimeRemain];
    [[NSUserDefaults standardUserDefaults] setObject:_park.isTakenNow   forKey:kIsTakenNow];
    
    [[NSUserDefaults standardUserDefaults] setObject:_park.rankCounter  forKey:kRankCounter];
    [[NSUserDefaults standardUserDefaults] setObject:_park.rankTotal    forKey:kRankTotal];
    [[NSUserDefaults standardUserDefaults] setObject:_park.favorit      forKey:kFavorit];

    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
}









@end
