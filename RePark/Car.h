//
//  Car.h
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

@property (nonatomic, strong) NSString *carColorID;

@property (nonatomic, strong) NSString *carID;

@property (nonatomic, strong) NSString *carImagePath;

@property (nonatomic, strong) NSString *carNumber;

@property (nonatomic, strong) NSString *carSizeID;

@property (nonatomic, strong) NSString *carTypeID;

@property (nonatomic, strong) NSString *totalSpent;

@property (nonatomic, strong) NSString *userID;


- (Car *) initWithInfo:(NSDictionary*)info;

@end
