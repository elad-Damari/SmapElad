//
//  AddNewPark.h
//  RePark
//
//  Created by Elad Damari on 11/19/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;


@interface AddNewPark : UIViewController
<UITextFieldDelegate>

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end
