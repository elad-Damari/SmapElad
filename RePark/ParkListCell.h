//
//  ParkListCell.h
//  RePark
//
//  Created by Elad Damari on 11/9/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *myLabel;

- (void) configureCellWithPark: (Park *) park;

@end
