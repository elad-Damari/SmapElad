//
//  MapController.h
//  RePark
//
//  Created by Nadav Kershner on 11/5/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
