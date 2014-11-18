//
//  MJPopUpController.h
//  ViewControllerDemo
//
//  Created by Nadav Kershner on 11/7/14.
//  Copyright (c) 2014 Nadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface MJPopUpController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *list;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end

@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(MJPopUpController*)popUpController clickedRowAtIndex:(NSUInteger)index;

@end
