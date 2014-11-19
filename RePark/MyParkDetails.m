//
//  MyParkDetails.m
//  RePark
//
//  Created by Elad Damari on 11/19/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "MyParkDetails.h"
#import "UIViewController+MJPopupViewController.h"

@interface MyParkDetails ()
{
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UILabel *parkIdLabel;

@property (weak, nonatomic) IBOutlet UILabel *parkAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *parkIsTakenLabel;


@property (weak, nonatomic) IBOutlet UILabel *carIsInParkLabel;

@property (weak, nonatomic) IBOutlet UILabel *carNumberLavel;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *carColorLabel;

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;


- (IBAction)cancelButton:(id)sender;


@end


@implementation MyParkDetails


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self setViewsOnScreen];

}


- (IBAction)cancelButton:(id)sender

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void) setViewsOnScreen

{
    
    //_parkAddressLabel.text = _park.addressID;
    
    _parkAddressLabel.hidden = YES;
    
    _parkIdLabel.text      = [NSString stringWithFormat:@"%@", _park.parkID];
    
    
    NSString *taken = [NSString stringWithFormat:@"%@", _park.isTakenNow];
    
    if ([taken isEqualToString:@"1"])
        
    {
        
        _parkIsTakenLabel.text = @"תפוס";
        
        _carNumberLavel.text   = _car.carNumber;
        
        NSString *type         = [NSString stringWithFormat:@"%@", _car.carTypeID];
        
        int typeNumber         = [type intValue];

        _carTypeLabel.text     = [[appDelegate.dataBase objectForKey:kCarTypeID]
                                  objectAtIndex:typeNumber];
        
        NSString *color        = [NSString stringWithFormat:@"%@", _car.carColorID];
        
        int colorNumber        = [color intValue];
        
        _carColorLabel.text    = [[appDelegate.dataBase objectForKey:kCarColorID]
                                  objectAtIndex:colorNumber];
        
    }
    
    else
        
    {
        
        _parkIsTakenLabel.text = @"פנוי";
        
        
        _carIsInParkLabel.hidden = YES;
        
        _carNumberLavel.hidden   = YES;
        
        _carTypeLabel.hidden     = YES;
        
        _carColorLabel.hidden    = YES;
        
        
    }
    
    
    
    

}











@end
