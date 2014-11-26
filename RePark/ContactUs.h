//
//  ContactUs.h
//  RePark
//
//  Created by Elad Damari on 11/25/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface ContactUs : UIViewController

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end
