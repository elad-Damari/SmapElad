//
//  MyParkDetails.h
//  RePark
//
//  Created by Elad Damari on 11/19/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MJPopUpControllerDelegate;


@interface MyParkDetails : UIViewController


@property (nonatomic, strong) Park *park;

@property (nonatomic, strong) Car  *car;


@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end





@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(MyParkDetails *)popUpController withParkData: (NSDictionary *) data;

@end