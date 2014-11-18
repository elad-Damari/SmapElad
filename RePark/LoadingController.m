//
//  LoadingController.m
//  RePark
//
//  Created by Nadav Kershner on 11/3/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "LoadingController.h"

@interface LoadingController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation LoadingController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    //if the device has big screen - set big image
    
    if (IS_IPHONE4) {
        
        _imageView.image = [UIImage imageNamed:@"Default-568h"];
    
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    //check if user is connected

    if ([self.defaults stringForKey:kAccessToken]) {
        
        //yes - go to home screen
        
        [self performSegueWithIdentifier:kSegueHome sender:nil];
        
    } else {
    
        //no - go to login screen
        
        [self performSegueWithIdentifier:kSegueLogin sender:nil];
    
    }
    
}

@end
