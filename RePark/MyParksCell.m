//
//  MyParksCell.m
//  RePark
//
//  Created by Elad Damari on 11/18/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "MyParksCell.h"

@implementation MyParksCell


- (void) configureCellWithMyPark: (Park *) park

{
    //check if ther are car details in park...
    
    //_carIdLabel.text = car.carID;
    //_carNumberLabel.text = car.carNumber;
    //_carTypeLabel.text   = car.carType;
    
    _pricePerHour.text = park.pricePerHour;
    
    _parkIdLabel.text  = park.parkID;
    
    if ([park.isTakenNow isEqualToString:@"0"])
    {
        _isTakenLabel.text = @"תפוס";
        _isTakenLabel.backgroundColor = [UIColor redColor];
    }
    else
    {
        _isTakenLabel.text = @"פנוי";
        _isTakenLabel.backgroundColor = [UIColor greenColor];
    }
    
    
}

@end
