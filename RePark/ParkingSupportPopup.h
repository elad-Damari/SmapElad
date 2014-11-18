//
//  ParkingSupportPopup.h
//  RePark
//
//  Created by Elad Damari on 11/12/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import <UIKit/UIKit.h>


// 1. add protocol so that delegate obj will know this popup class.
@protocol MJPopUpControllerDelegate;

@interface ParkingSupportPopup : UIViewController

// 2. add some property to initialize with data by creating
//    this class VC instance before poping it up.
@property (nonatomic, strong) NSString *passedData;

// 3. add this property to make it the popup delegate.
@property (assign, nonatomic) id <MJPopUpControllerDelegate> delegate;

@end

// go to controller popup that is calling this popup to see ferther instractions at #4 (start with #import).

//// 4. add another call to the popup protocol to be known in the homecontroller
//@protocol MJPopUpControllerDelegate <NSObject>
//
//@optional
//
//// 5. add relevant method by popup protocol type...
////    data passing will be from the homecontroller .m file... this is the
////    same method from home controller that calls this class popup to appear...
//
//- (void)popUp:(ParkingSupportPopup *)popUpController clickedSupport:(NSString *) dataToPasss;
//
//@end

// go to home controller to see ferther instractions at #6 (start with #import).



