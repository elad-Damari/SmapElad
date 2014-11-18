//
//  MyParksCell.h
//  RePark
//
//  Created by Elad Damari on 11/18/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyParksCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *carIdLabel;

//@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;

//@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *pricePerHour;

@property (weak, nonatomic) IBOutlet UILabel *isTakenLabel;

@property (weak, nonatomic) IBOutlet UILabel *parkIdLabel;

- (void) configureCellWithMyPark: (Park *) park;

@end
