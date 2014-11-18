//
//  CarListCellTableViewCell.h
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"


@interface CarListCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *CarNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *isDefaultLabel;

@property (weak, nonatomic) IBOutlet UIImageView *carImageView;


- (void) configureCellWithCar: (Car *) car;

@end
