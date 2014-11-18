//
//  UIAlertView+CustomAlertView.m
//  RePark
//
//  Created by Nadav Kershner on 11/5/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "UIAlertView+CustomAlertView.h"

@implementation UIAlertView (CustomAlertView)

+(void)alertWithTitle:(NSString *)title{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"אישור" otherButtonTitles:nil];
    
    [alert show];

}

@end
