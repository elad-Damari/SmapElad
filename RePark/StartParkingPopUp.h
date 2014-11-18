//
//  StartParkingPopUp.h
//  RePark
//
//  Created by Elad Damari on 11/11/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MJPopUpControllerDelegate;

@interface StartParkingPopUp : UIViewController

@property (strong, nonatomic)              Park *park;

@property (strong, nonatomic)          NSString *parkingTimeRemains;

@property (strong, nonatomic)          NSString *parkLogID;

@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end


// 4. add another call to the popup protocol to be known in the homecontroller
@protocol MJPopUpControllerDelegate <NSObject>

@optional

// 5. add relevant method by popup protocol type...
//    data passing will be from the homecontroller .m file... this is the
//    same method from home controller that calls this class popup to appear... set class as this class

- (void)popUp:(StartParkingPopUp *)popUpController clickedSupport:(NSString *) dataToPasss;

- (void)popUp:(StartParkingPopUp *)popUpController clickedEnd:(Park *) dataToPasss;

- (void)popUp:(StartParkingPopUp *)popUpController clickedGate:(Park *) dataToPasss;

- (void)popUp:(StartParkingPopUp *)popUpController clickedExtension:(NSString *) dataToPasss;

@end

// go to home controller to see ferther instractions at #6 (start with #import).

