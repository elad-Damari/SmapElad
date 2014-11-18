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

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

- (IBAction)closeButton:(id)sender;


@end


