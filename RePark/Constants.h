//
//  Constants.h
//  Azur
//
//  Created by Nadav Kershner on 7/9/14.
//  Copyright (c) 2014 Nadav. All rights reserved.
//

#ifndef Azur_Constants_h

#define Azur_Constants_h

#pragma mark - Server adrress & services
static NSString * const kServerAdrress         = @"http://www.navigazo.co.il/yaniv/rePark/service.php";
static NSString * const kService               = @"service";
static NSString * const kGetAllParks           = @"getAllParks";
static NSString * const kSearchParksForNow     = @"searchParksForNow";
static NSString * const kSearchParksForReservation = @"searchParksForReservation";
static NSString * const kOrderReservation      = @"orderReservation";
static NSString * const kGetParkSlots          = @"getParkSlots";
static NSString * const kAddToFavorite         = @"addToFavorite";
static NSString * const kDelFromFavorite       = @"delFromFavorite";
static NSString * const kAddPark               = @"addPark";
static NSString * const kAddCar                = @"addCar";
static NSString * const kStartParkServiceKey   = @"startPark";
static NSString * const kEndParkServiceKey     = @"endPark";
static NSString * const kOpenParkGate          = @"openParkGate";
static NSString * const kAskForExtension       = @"askForExtension";
static NSString * const kGetMyFavoriteParks    = @"getMyFavoriteParks";
static NSString * const kGetMyCars             = @"getMyCars";
static NSString * const kGetMyParks            = @"getMyParks";
static NSString * const kChangePark            = @"changePark";


#pragma mark - Server Keys For Requests
static NSString * const kLatitudeRequest       = @"userLat";
static NSString * const kLongtitudeRequest     = @"userLong";
static NSString * const kUserLoaction          = @"userLoaction";
static NSString * const kOrderByRequest        = @"orderBy";
static NSString * const kRadiusRequest         = @"radius";
static NSString * const kPricePerDayRequest    = @"pricePerDay";
static NSString * const kpricePerHourRequest   = @"pricePerHour";
static NSString * const kParkIDtoSearchRequest = @"parkIDtoSearch";
static NSString * const kCarID                 = @"carID";
static NSString * const kParkToFavorites       = @"parkToFavorites";
static NSString * const kParkToDelFromFavorites= @"parkToDelFromFavorites";
static NSString * const kDate                  = @"date";
static NSString * const kStartHour             = @"startHour";
static NSString * const kEndHour               = @"endHour";
static NSString * const kLogID                 = @"logID";
static NSString * const kTimeToExtend          = @"timeToExtend";




#pragma mark - User Defaults keys
static NSString * const kAccessToken        = @"accessToken";

#pragma mark - Cell Identifier
static NSString * const kCustomCell         = @"CustomCell";

#pragma mark - Segue Identifier
static NSString * const kSegueHome          = @"Home";
static NSString * const kSegueLogin         = @"Login";
static NSString * const kSegueRegister      = @"Register";
static NSString * const kSegueValidate      = @"Validate";

#pragma mark - Park keys
static NSString * const kParkID             = @"parkID";
static NSString * const kUserID             = @"userID";
static NSString * const kSizeID             = @"sizeID";
static NSString * const kGateID             = @"gateID";
static NSString * const kParkTopID          = @"topID";
static NSString * const kParkTypeID         = @"typeID";
static NSString * const kParkComments       = @"parkComments";

static NSString * const kParkImagePath      = @"parkImagePath";
static NSString * const kBuildingImagePath  = @"buildingImagePath";

static NSString * const kAddressID          = @"location";
static NSString * const kLatitude           = @"latitude";
static NSString * const kLongtitude         = @"longtitude";
static NSString * const kDistance           = @"distance";

static NSString * const kPricePerDay        = @"pricePerDay";
static NSString * const kPricePerHour       = @"pricePerHour";

static NSString * const kStartTime          = @"startTime";
static NSString * const kEndTime            = @"endTime";
static NSString * const kIsTakenNow         = @"isTakenNow";
static NSString * const kTimeRemain         = @"timeRemain";

static NSString * const kRankCounter        = @"rankCounter";
static NSString * const kRankTotal          = @"rankTotal";
static NSString * const kFavorit            = @"favorite";


#pragma mark - Car Keys
static NSString * const kCarColorID         = @"carColorID";
static NSString * const kCarId              = @"carID";
static NSString * const kCarImagePath       = @"carImagePath";
static NSString * const kCarNumber          = @"carNumber";
static NSString * const kCarSizeID          = @"carSizeID";
static NSString * const kCarTypeID          = @"carTypeID";
static NSString * const kTotalSpent         = @"totalSpent";
static NSString * const kUserId             = @"userID";

#pragma mark - Location Keys
static NSString * const kUserLat            = @"userLat";
static NSString * const kUserLng            = @"userLng";
static NSString * const kDefaultRadius      = @"defaultRadius";

#pragma mark - Handler Methods
static NSString * const kParkHours          = @"parkHours";
static NSString * const kRentHoursRemains   = @"rentHoursRemains";


#pragma mark - Nib names

#pragma mark - Alert message
static NSString * const kAlertMessageDetailsWrong  = @"נתונים שהזנת שגויים";

#define IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height!=568)

#define SYSTEM_VERSION_LESS_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/*
 #pragma mark - View lifecycle
 #pragma mark - Delegate methods
 #pragma mark - IBAction methods
 #pragma mark - Public methods
 #pragma mark - Private methods
 #pragma mark - Setter methods
 */

#endif
