//
//  AppDelegate.m
//  RePark
//
//  Created by Nadav Kershner on 11/2/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize dataBase;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialzie methods
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"initializeDataBase" ofType:@"plist"];
    dataBase = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"bec80288fe84f585cb83dda71cabe1a351e1c8fe27bd68e688a9aa0dffaf9ecf30353036383331353431"
                                              forKey:kAccessToken];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"homeScreen" forKey:@"whichList" ];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0525413136" forKey:@"costumerSupportNumber"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0505906366" forKey:@"parkOwnerNumber"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1"          forKey:@"defaultCarId"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"11"          forKey:@"userType"];
    
    // replace with initial methods....
    
    [[NSUserDefaults standardUserDefaults] setObject:@"פרטי"        forKey:@"size0"];
    [[NSUserDefaults standardUserDefaults] setObject:@"ג'יפ"        forKey:@"size1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"קטן"         forKey:@"size2"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"אין"         forKey:@"gate1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"שלט"        forKey:@"gate2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"טלפון"        forKey:@"gate3"];
    [[NSUserDefaults standardUserDefaults] setObject:@"שומר"        forKey:@"gate4"];

    [[NSUserDefaults standardUserDefaults] setObject:@"מקורה"       forKey:@"top1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"פתוחה"       forKey:@"top2"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"מגורים"       forKey:@"type1"];
    [[NSUserDefaults standardUserDefaults] setObject:@"משרדים"      forKey:@"type2"];
    [[NSUserDefaults standardUserDefaults] setObject:@"חניון"        forKey:@"type3"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

@end
