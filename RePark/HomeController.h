//
//  HomeController.h
//  RePark
//
//  Created by Nadav Kershner on 11/3/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "MapController.h"
#import "CDSideBarController.h"

@interface HomeController : MapController <CDSideBarControllerDelegate>

{
    CDSideBarController *sideBar;
}
@property (weak, nonatomic) IBOutlet UIView *bottomMenu;

- (IBAction)openParkListPopUpController:(id)sender;

@end
