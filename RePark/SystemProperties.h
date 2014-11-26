//
//  SystemProperties.h
//  RePark
//
//  Created by Elad Damari on 11/25/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface SystemProperties : UIViewController

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end




@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUpContactUs:(SystemProperties *)popUpController;

@end