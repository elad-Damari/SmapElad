//
//  MyParksList.h
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface MyParksList : UIViewController
<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myParksTableView;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) NSArray *carList;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

- (IBAction)closeButton:(id)sender;


@end



@protocol MJPopUpControllerDelegate <NSObject>

@optional

- (void)popUp:(MyParksList *)popUpController clickedMyPark:(Park *)park withCar:(Car *)car;

- (void)popUp:(MyParksList *)popUpController;

@end
