//
//  ParkDetailPopUp.h
//  RePark
//
//  Created by Elad Damari on 11/10/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface ParkDetailPopUp : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate>


@property (strong, nonatomic)     Park *parkingSpotToPass;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end



@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(ParkDetailPopUp *)popUpController clickedButton:(Park *) park;

- (void)popUp:(ParkDetailPopUp *)popUpController clickedOrder:(Park *) park;

@end
