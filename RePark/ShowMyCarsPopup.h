//
//  ShowMyCarsPopup.h
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface ShowMyCarsPopup : UIViewController

@property (strong, nonatomic) NSArray *list;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end



@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void) popUpCar:(ShowMyCarsPopup *)popUpController;

@end