//
//  ParkListPopUpController.h
//  RePark
//
//  Created by Elad Damari on 11/9/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;



@interface ParkListPopUpController : UIViewController

//<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *list;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end




@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(ParkListPopUpController *)popUpController clickedPark:(Park *)park;

@end