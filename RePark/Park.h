//
//  Park.h
//  RePark
//
//  Created by Elad Damari on 11/9/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Park : NSObject

@property (nonatomic, strong) NSString *parkID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *sizeID;
@property (nonatomic, strong) NSString *gateID;
@property (nonatomic, strong) NSString *topID;
@property (nonatomic, strong) NSString *typeID;
@property (nonatomic, strong) NSString *parkComments;

@property (nonatomic, strong) NSString *parkImagePath;
@property (nonatomic, strong) NSString *buildingImagePath;

@property (nonatomic, strong) NSString *addressID;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longtitude;
@property (nonatomic, strong) NSString *distance;

@property (nonatomic, strong) NSString *pricePerDay;
@property (nonatomic, strong) NSString *pricePerHour;

@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *timeRemain;
@property (nonatomic, strong) NSString *isTakenNow;

@property (nonatomic, strong) NSString *rankCounter;
@property (nonatomic, strong) NSString *rankTotal;
@property (nonatomic, strong) NSString *favorit;


- (Park *) initWithInfo:(NSDictionary*)info;

@end
