//
//  ContactUsPopupController.h
//  RePark
//
//  Created by Elad Damari on 11/12/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface ContactUsPopupController : UIViewController

@property (strong, nonatomic) NSString *userIDtoPass;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end


