//
//  Park.m
//  RePark
//
//  Created by Elad Damari on 11/9/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "Park.h"

@implementation Park


- (Park *) initWithInfo:(NSDictionary*)info

{
    self = [super init];
    
    if (self)
        
    {

        _parkID            = info[kParkID];
        _userID            = info[kUserID];
        _sizeID            = info[kSizeID];
        _gateID            = info[kGateID];
        _topID             = info[@"parkTopID"];
        _typeID            = info[@"parkTypeID"];
        _parkComments      = info[kParkComments];
        
        _parkImagePath     = info[kParkImagePath];
        _buildingImagePath = info[kBuildingImagePath];
        
        _addressID         = info[kAddressID];
        _latitude          = info[kLatitude];
        _longtitude        = info[kLongtitude];
        _distance          = info[kDistance];
        
        _pricePerDay       = info[kPricePerDay];
        _pricePerHour      = info[kPricePerHour];
        
        _startTime         = info[kStartTime];
        _endTime           = info[kEndTime];
        _isTakenNow        = info[kIsTakenNow];
        _timeRemain        = info[kTimeRemain];
        
        _rankCounter       = info[kRankCounter];
        _rankTotal         = info[kRankTotal];
        _favorit           = info[kFavorit];

    }
    
    return self;
    
}




@end
