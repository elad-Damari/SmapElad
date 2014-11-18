//
//  CarListCellTableViewCell.m
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "CarListCellTableViewCell.h"

@implementation CarListCellTableViewCell

@synthesize carTypeLabel, CarNumberLabel, carImageView, isDefaultLabel;


- (void) configureCellWithCar:(Car *)car

{
    
    NSString *carSize        = [NSString stringWithFormat:@"size%@", car.carSizeID];
    
    NSString *carSizeText    = [[NSUserDefaults standardUserDefaults] objectForKey:carSize];
    
    NSString *defaultCarId   = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultCarId"];
    
    self.carTypeLabel.text   = carSizeText;
    
    self.CarNumberLabel.text = car.carNumber;
    
    if ([defaultCarId isEqualToString:car.carID])
    {
    
        self.isDefaultLabel.hidden  = NO;
        
        self.isDefaultLabel.text   = @"V";
        
    }
    
    else
        
    {
        
        self.isDefaultLabel.hidden = YES;
        
    }
    
    //self.carImageView = car.carImagePath;
    
}

@end

