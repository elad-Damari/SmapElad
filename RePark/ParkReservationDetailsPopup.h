//
//  ParkReservationDetailsPopup.h
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface ParkReservationDetailsPopup : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>



@property (strong, nonatomic) IBOutlet UIPickerView *carIdPickerView;

@property (strong, nonatomic) Park     *parkDetails;

@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *startTime;

@property (strong, nonatomic) NSString *endTime;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end






