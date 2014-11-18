//
//  Car.m
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "Car.h"

@implementation Car


- (Car *) initWithInfo:(NSDictionary*)info

{
    self = [super init];
    
    if (self)
        
    {
        
        _carColorID   = info[kCarColorID];
        _carID        = info[kCarID];
        _carImagePath = info[kCarImagePath];
        _carNumber    = info[kCarNumber];
        _carSizeID    = info[kCarSizeID];
        _carTypeID    = info[kCarTypeID];
        _totalSpent   = info[kTotalSpent];
        _userID       = info[kUserID];

    }
    
    return self;

}
@end
