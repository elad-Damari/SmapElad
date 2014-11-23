//
//  AddNewCar.h
//  RePark
//
//  Created by Elad Damari on 11/20/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface AddNewCar : UIViewController

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end
