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

    _pricePerHour.text = [NSString stringWithFormat:@"%@", park.pricePerHour];
    
    _parkIdLabel.text  = [NSString stringWithFormat:@"%@", park.parkID];
    
    NSString *taken = [NSString stringWithFormat:@"%@", park.isTakenNow];
    
    if ([taken isEqualToString:@"1"])
    {
        _isTakenLabel.text = @"תפוס";
        _isTakenLabel.backgroundColor = [UIColor redColor];
        

    }
    else
    {
        _isTakenLabel.text = @"פנוי";
        _isTakenLabel.backgroundColor = [UIColor greenColor];
        
        _carIdTitleLabel.text = @"";
        _carNumberTitleLabel.text = @"";
        _carTypeTitleLabel.text = @"";
        
    }
    
    
}

@end
