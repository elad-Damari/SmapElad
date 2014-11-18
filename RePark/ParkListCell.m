//
//  ParkListCell.m
//  RePark
//
//  Created by Elad Damari on 11/9/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkListCell.h"
#import "Park.h"
#import <CoreLocation/CoreLocation.h>

@implementation ParkListCell

@synthesize addressLabel, distanceLabel, priceLabel, typeLabel, myLabel;

- (void) configureCellWithPark: (Park *) park

{
    
    self.addressLabel.text  = park.addressID;
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%d", [park.distance intValue]];
    
    self.priceLabel.text    = park.pricePerHour;
    
    self.typeLabel.text     = park.parkTypeID;
    
    if ([park.favorit isEqualToString:@"0"])
        
    {
        
        myLabel.text = @"X";
        
    }
    
    else
        
    {
        
        myLabel.text = @"V";
        
    }
    
}


- (IBAction)changeLbl:(id)sender
{
    if ([myLabel.text isEqualToString:@"V"])
    {
        // cahnge to x
        myLabel.text = @"X";
        //call change method...
    }
    else
    {
        // cahnge to x
        myLabel.text = @"V";
        //call change method...
    }
}












@end
