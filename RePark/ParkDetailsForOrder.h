//
//  ParkDetailsForOrder.h
//  RePark
//
//  Created by Elad Damari on 11/18/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface ParkDetailsForOrder : UIViewController

@property (strong, nonatomic)     Park *parkingSpotToPass;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end



@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(ParkDetailsForOrder *)popUpController clickedParkReservation:(Park *) dataToPasss withDate: (NSString*) dateToPass startTime: (NSString *) startTimeToPass andEndTime: (NSString *) endTimeToPass;

@end