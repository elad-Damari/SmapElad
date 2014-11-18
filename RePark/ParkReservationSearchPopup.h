//
//  ParkReservationSearchPopup.h
//  RePark
//
//  Created by Elad Damari on 11/16/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CoreLocation/CoreLocation.h>

@protocol MJPopUpControllerDelegate;


@interface ParkReservationSearchPopup : UIViewController
<UITextFieldDelegate>

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end



@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(ParkReservationSearchPopup *)popUpController clickedReservation:(NSArray *) dataToPasss;


@end