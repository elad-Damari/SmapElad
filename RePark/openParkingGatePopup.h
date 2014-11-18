//
//  openParkingGatePopup.h
//  RePark
//
//  Created by Elad Damari on 11/13/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MJPopUpControllerDelegate;

@interface openParkingGatePopup : UIViewController

@property (nonatomic, strong) Park *passedData;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end
