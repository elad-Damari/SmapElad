//
//  HomeController.m
//  RePark
//
//  Created by Nadav Kershner on 11/3/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "HomeController.h"

#import "MZFormSheetSegue.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"

#import "AFNetworking.h"

#import "Park.h"
#import "ParkListPopUpController.h"
#import "ParkDetailPopUp.h"
#import "StartParkingPopUp.h"
#import "EndParkingPopup.h"
#import "openParkingGatePopup.h"
#import "ParkExtensionPopup.h"
#import "ParkReservationSearchPopup.h"
#import "ParkResrvationListPopup.h"
#import "ParkReservationDetailsPopup.h"
#import "ShowMyCarsPopup.h"
#import "ParkDetailsForOrder.h"
#import "MyParksList.h"
#import "MyParkDetails.h"
#import "AddNewPark.h"
#import "AddNewCar.h"

#import "MyProfilePopup.h"
#import "SystemProperties.h"
#import "ContactUs.h"


//6. import relevant class .h file. this is the class  you want to popup .h file
#import "ParkingSupportPopup.h"

@interface HomeController ()

<MJPopUpControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

{
    
    ParkListPopUpController *parkListPopUp;
    
    ParkDetailPopUp         *parkDetailPopUp;
    
    StartParkingPopUp       *startParkingPopUp;
    
    // create instance of the class you wnat to pop up...
    ParkingSupportPopup     *parkingSupportPopup;
    
    EndParkingPopup         *endParkingPopup;
    
    openParkingGatePopup    *openParkingGatePopUp;
    
    ParkExtensionPopup      *parkExtensionPopup;
    
    ParkReservationSearchPopup *parkReservationSearchPopup;
    
    ParkResrvationListPopup *parkResrvationListPopup;
    
    ParkReservationDetailsPopup *parkReservationDetailsPopup;
    
    ShowMyCarsPopup         *showMyCarsPopup;
    
    MyParksList             *myParksList;
    
    MyParkDetails           *myParkDetails;
    
    ParkDetailsForOrder     *parkDetailsForOrder;
    
    AddNewPark              *addNewPark;
    
    AddNewCar               *addNewCar;
    
    MyProfilePopup          *myProfilePopup;
    
    SystemProperties        *systemProperties;
    
    ContactUs               *contactUs;
    
    
    NSMutableDictionary     *parametersDictionary;
    
    CLLocation              *userLocation;
    
    CLLocationManager       *locationManager;
    
    CLLocationCoordinate2D  addressGeo;
    
    UILabel                 *val;
    
    UILabel                 *txt;
    
    NSString                *sort;
    
    BOOL                    firstTimeShowSlider;
    
    
    
}

@property (weak, nonatomic) IBOutlet UIButton    *searchParkByAddressOutlet;

@property (weak, nonatomic) IBOutlet UITextField *searchParkByAddressField;

@property (weak, nonatomic) IBOutlet UISlider    *searchParkRadiusSlider;

@property (strong, nonatomic) NSArray            *parks;

@property (strong, nonatomic) NSNumber           *sliderVal;

@property (strong, nonatomic) NSData             *response;


- (IBAction)searchParkByAddressButton:(id)sender;

- (IBAction)radiusSliderValChanged:(id)sender;

- (IBAction)searchParksReservation:(id)sender;

- (IBAction)openActiveParkButton:(id)sender;

- (IBAction)openMyCarsButton:(id)sender;

- (IBAction)openMyParksButton:(id)sender;

- (IBAction)openFilterMapMenuButton:(id)sender;

- (IBAction)openFavoriteParksList:(id)sender;



- (IBAction)openBottomMenu:(id)sender;

- (IBAction)openLogout:(id)sender;

- (IBAction)openCalender:(id)sender;

- (IBAction)openAlert:(id)sender;

- (IBAction)openHistory:(id)sender;

- (IBAction)openSystem:(id)sender;

- (IBAction)openProfile:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *bottomBackground;

@end



@implementation HomeController

@synthesize bottomMenu;


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated

{
    
    [self setViewsDesign];

    firstTimeShowSlider = YES;
    
}


- (void)viewDidLoad

{
    [super viewDidLoad];
    
    [self getUserLocation];

    
//    side bar methods...
//    NSArray *imageList = @[[UIImage imageNamed:@"menuChat.png"], [UIImage imageNamed:@"menuUsers.png"],
//                           [UIImage imageNamed:@"menuMap.png"], [UIImage imageNamed:@"menuClose.png"]];
//    
//    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
//    sideBar.delegate = self;

    
    
    //[self getAllParksList]; & show on map ...
    // ************************************************************************
    // * show parks on map by relevant filter and center map by user location *
    // ************************************************************************

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[sideBar insertMenuButtonOnView:[UIApplication sharedApplication].delegate.window atPosition:CGPointMake(self.view.frame.size.width - 72, 500)];
}


- (void)menuButtonClicked:(int)index
{
    //NSLog(@"subviews: \n %@", [self.view subviews]);
    
//    UIButton *btn = (UIButton *)[self.view viewWithTag:index];
//    btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuChatOn.png"]];
    
}

#pragma mark - Action Methods

- (IBAction)searchParkByAddressButton:(id)sender

{
    
    [self hideMyKeyboard:_searchParkByAddressField];

    addressGeo = [self geoCodeUsingAddress:self.searchParkByAddressField.text];
 
//    *********** location log **************
//    int radiusVal = [val.text intValue];
//    NSLog(@"\n address geo lat = %f \n address geo lng = %f \n address search radius = %d"
//         , addressGeo.latitude, addressGeo.longitude, radiusVal);
    
    if (addressGeo.latitude == 0 || addressGeo.longitude == 0)
    {
        // **************************************************************************
        // * address not valid, ask user to enter another address by alert view !!! *
        // **************************************************************************
        
        NSLog(@"\n address not valid, ask user to enter another address by alert view !!!");
    }
    
    else
        
    {
        
        NSDictionary *parameters = [self getParametersForServerRequestName:kSearchParksForNow
                                                                 AndSortBy:kAddressID];
        
        [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
        
    }
    
   
    
}

- (IBAction)showPopUp:(UIButton*)sender
{
    
    NSString *identifier = [sender titleForState:UIControlStateNormal];
    
    [self performSegueWithIdentifier:identifier sender:nil];
    
}

- (IBAction)openParkListPopUpController:(id)sender
{

    //get list of valid parks for now  by default radius...
    
    NSDictionary *parameters = [self getParametersForServerRequestName:kSearchParksForNow
                                                             AndSortBy:kDistance];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
    
    // ****************************************
    // * call loading spinner                 *
    // ****************************************
    
}

- (void) showRelevantParksOnMap

{
    // ****************************************
    // * show Relevant Parks On Map           *
    // ****************************************
}


- (void) getAllParksList

{
    
    NSDictionary *parameters = [self getParametersForServerRequestName:kGetAllParks
                                                             AndSortBy:kDistance];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
    //[self showRelevantParksOnMap];
    
}



- (void) openListOfRelevantParks

{
    
    parkListPopUp          = [[ParkListPopUpController alloc] init];
    
    parkListPopUp.delegate = self;
    
    parkListPopUp.list     = self.parks;
    
    [self presentPopupViewController:parkListPopUp animationType:MJPopupViewAnimationSlideRightRight];
    
}



- (IBAction)searchParksReservation:(id)sender

{
    
    parkReservationSearchPopup = [[ParkReservationSearchPopup alloc] init];
    
    parkReservationSearchPopup.delegate = self;
    
    [self presentPopupViewController:parkReservationSearchPopup animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (IBAction)openActiveParkButton:(id)sender

{
    

    Park *park = [[Park alloc] init];
    
    park.parkID = [[NSUserDefaults standardUserDefaults] objectForKey:kParkID];
    
    if ([park.parkID isEqualToString:@""])
    {
        PXAlertView *alert =[PXAlertView showAlertWithTitle:@"כרגע אין חניה פעילה"
                                                    message:nil
                                                cancelTitle:@"אישור"
                                                 completion:^(BOOL cancelled, NSInteger buttonIndex)
                             {
                                 if (cancelled)
                                 {
                                     NSLog(@"Simple Alert View cancelled");
                                     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                 }
                                 else
                                 {
                                     NSLog(@"Simple Alert View dismissed, but not cancelled");
                                     
                                 }}];
        [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
    }
    
    else
    {
        park.userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
        park.sizeID = [[NSUserDefaults standardUserDefaults] objectForKey:kSizeID];
        park.gateID = [[NSUserDefaults standardUserDefaults] objectForKey:kGateID];
        park.topID = [[NSUserDefaults standardUserDefaults] objectForKey:kParkTopID];
        park.typeID = [[NSUserDefaults standardUserDefaults] objectForKey:kParkTypeID];
        park.parkComments = [[NSUserDefaults standardUserDefaults] objectForKey:kParkComments];
        
        park.parkImagePath = [[NSUserDefaults standardUserDefaults] objectForKey:kParkImagePath];
        park.buildingImagePath = [[NSUserDefaults standardUserDefaults] objectForKey:kBuildingImagePath];
        
        park.addressID = [[NSUserDefaults standardUserDefaults] objectForKey:kAddressID];
        park.latitude = [[NSUserDefaults standardUserDefaults] objectForKey:kLatitude];
        park.longtitude = [[NSUserDefaults standardUserDefaults] objectForKey:kLongtitude];
        park.distance = [[NSUserDefaults standardUserDefaults] objectForKey:kDistance];
        
        park.pricePerDay = [[NSUserDefaults standardUserDefaults] objectForKey:kPricePerDay];
        park.pricePerHour = [[NSUserDefaults standardUserDefaults] objectForKey:kPricePerHour];
        
        park.startTime = [[NSUserDefaults standardUserDefaults] objectForKey:kStartTime];
        park.endTime = [[NSUserDefaults standardUserDefaults] objectForKey:kEndTime];
        park.timeRemain = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeRemain];
        park.isTakenNow = [[NSUserDefaults standardUserDefaults] objectForKey:kIsTakenNow];
        
        park.rankCounter = [[NSUserDefaults standardUserDefaults] objectForKey:kRankCounter];
        park.rankTotal = [[NSUserDefaults standardUserDefaults] objectForKey:kRankTotal];
        park.favorit = [[NSUserDefaults standardUserDefaults] objectForKey:kFavorit];
        
        
        
        startParkingPopUp              = [[StartParkingPopUp alloc] init];
        
        startParkingPopUp.delegate     = self;
        
        startParkingPopUp.park = park;
        
        [self presentPopupViewController:startParkingPopUp animationType:MJPopupViewAnimationSlideRightRight];
    }
    

}




- (IBAction)openMyCarsButton:(id)sender

{
    
    showMyCarsPopup = [[ShowMyCarsPopup alloc] init];
    
    showMyCarsPopup.delegate = self;
    
    [self presentPopupViewController:showMyCarsPopup animationType:MJPopupViewAnimationSlideRightRight];
    
    
    
}









- (IBAction)openFilterMapMenuButton:(id)sender

{
    
    
    
    
    
}



- (IBAction)openFavoriteParksList:(id)sender

{

    NSDictionary *parameters = [self getParametersForServerRequestName:kGetMyFavoriteParks
                                                             AndSortBy:kFavorit];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
    
}









- (IBAction)openBottomMenu:(id)sender

{
    
    if (bottomMenu.frame.origin.y+ bottomMenu.frame.size.height > self.view.frame.size.height)
        // menu is hidden at bottom ...
    {
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             [bottomMenu setFrame:
              CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width, 70)];
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    else                                 // menu is already opne...
    {
        [UIView animateWithDuration:0.4
                              delay:0
                            options: UIViewAnimationCurveEaseIn
                         animations:^
         {
             [bottomMenu setFrame:
              CGRectMake(0, self.view.frame.size.height-20, self.view.frame.size.width, 70)];
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
    
    
    
}



// nadav?
- (IBAction)openLogout:(id)sender
{
    
    NSLog(@"\n **** openLogout ");
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה ממתין כרגע להטמעה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
}





// not active for this version
- (IBAction)openCalender:(id)sender
{
    
    NSLog(@"\n **** openCalender ");
    
    
}



// not active for this version
- (IBAction)openAlert:(id)sender
{
    NSLog(@"\n **** openAlert ");
    
    
    
    
}





- (IBAction)openHistory:(id)sender

{
    NSLog(@"\n **** openHistory ");
    PXAlertView *alert =[PXAlertView showAlertWithTitle:@"שים לב !"
                                                message:@"מסך זה נמצא כרגע בבניה"
                                            cancelTitle:@"אישור"
                                             completion:^(BOOL cancelled, NSInteger buttonIndex)
                         {}];
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
    
    
    
}

- (IBAction)openSystem:(id)sender

{

    systemProperties          = [[SystemProperties alloc] init];
    
    systemProperties.delegate = self;
    
    [self presentPopupViewController:systemProperties animationType:MJPopupViewAnimationSlideRightRight];
    
}




- (IBAction)openProfile:(id)sender

{
    
    myProfilePopup          = [[MyProfilePopup alloc] init];
    
    myProfilePopup.delegate = self;
    
    [self presentPopupViewController:myProfilePopup animationType:MJPopupViewAnimationSlideRightRight];
    
}












// handle park details after park list popup dissmised

- (void)popUp:(ParkListPopUpController *)popUpController clickedPark:(Park *)park

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    parkDetailPopUp = [[ParkDetailPopUp alloc] init];
    
    parkDetailPopUp.delegate = self;

    parkDetailPopUp.parkingSpotToPass = park;

    [self presentPopupViewController:parkDetailPopUp animationType:MJPopupViewAnimationSlideRightRight];   
    
}


// handle park start reservation park list popup dissmised

- (void)popUp:(ParkDetailPopUp *)popUpController clickedButton:(Park *) park

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    startParkingPopUp              = [[StartParkingPopUp alloc] init];
    
    startParkingPopUp.delegate     = self;
    
    startParkingPopUp.park = park;
    
    [self presentPopupViewController:startParkingPopUp animationType:MJPopupViewAnimationSlideRightRight];
    
}


// 7. add & implemet relevant method.
//    actualy last popup dissmised, get relevant values and call start park

- (void)popUp:(ParkingSupportPopup *)popUpController clickedSupport:(NSString *) dataToPasss;

{
    
    // dissmis last vc popup.
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    // create wanted popup vc instance from class.
    
    parkingSupportPopup = [[ParkingSupportPopup alloc] init];
    
    // set instance delegate as it self.
    
    parkingSupportPopup.delegate = self;
    
    // intialize with data relevant property of instance ("passedData")
    parkingSupportPopup.passedData = @"987654321";
    
    // present the instance vc popup. (set relevant animation key...)
    
    [self presentPopupViewController:parkingSupportPopup animationType:MJPopupViewAnimationSlideRightRight];
    
    // go to new popup controller to implement log to see data passed...
    
}


- (void)popUp:(EndParkingPopup *)popUpController clickedEnd:(Park *) dataToPasss

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    endParkingPopup = [[EndParkingPopup alloc] init];
    
    endParkingPopup.delegate = self;
    
    endParkingPopup.passedData = dataToPasss;
    
    [self presentPopupViewController:endParkingPopup animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void)popUp:(openParkingGatePopup *)popUpController clickedGate:(Park *) dataToPasss
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    openParkingGatePopUp = [[openParkingGatePopup alloc] init];
    
    openParkingGatePopUp.delegate = self;
    
    openParkingGatePopUp.passedData = dataToPasss;
    
    [self presentPopupViewController:openParkingGatePopUp animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void)popUp:(ParkExtensionPopup *)popUpController clickedExtension:(NSString *) dataToPasss
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    parkExtensionPopup = [[ParkExtensionPopup alloc] init];
    
    parkExtensionPopup.delegate = self;
    
    parkExtensionPopup.passedData = dataToPasss;
    
    [self presentPopupViewController:parkExtensionPopup animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void)popUp:(ParkResrvationListPopup *)popUpController clickedReservation:(NSArray *) dataToPasss
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    parkResrvationListPopup = [[ParkResrvationListPopup alloc] init];
    
    parkResrvationListPopup.delegate = self;
    
    parkResrvationListPopup.list     = dataToPasss;
    
    [self presentPopupViewController:parkResrvationListPopup animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void)popUp:(ParkReservationDetailsPopup *)popUpController clickedParkReservation:(Park *) dataToPasss withDate: (NSString*) dateToPass startTime: (NSString *) startTimeToPass andEndTime: (NSString *) endTimeToPass
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    parkReservationDetailsPopup = [[ParkReservationDetailsPopup alloc] init];
    
    parkReservationDetailsPopup.delegate    = self;
    
    parkReservationDetailsPopup.parkDetails = dataToPasss;
    
    parkReservationDetailsPopup.date        = dateToPass;
    
    parkReservationDetailsPopup.startTime   = startTimeToPass;
    
    parkReservationDetailsPopup.endTime     = endTimeToPass;
    
    [self presentPopupViewController:parkReservationDetailsPopup animationType:MJPopupViewAnimationSlideRightRight];
    
}



- (void)popUp:(ParkDetailsForOrder *)popUpController clickedOrder:(Park *) park

{
    
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    parkDetailsForOrder = [[ParkDetailsForOrder alloc] init];
    
    parkDetailsForOrder.delegate = self;
    
    parkDetailsForOrder.parkingSpotToPass = park;
    
    [self presentPopupViewController:parkDetailsForOrder animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void)popUp:(MyParkDetails *)popUpController clickedMyPark:(Park *)park withCar:(Car *)car

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    myParkDetails = [[MyParkDetails alloc] init];
    
    myParkDetails.delegate = self;
    
    myParkDetails.park = park;
    
    myParkDetails.car = car;
    
    [self presentPopupViewController:myParkDetails animationType:MJPopupViewAnimationSlideRightRight];
}


- (IBAction)openMyParksButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    myParksList = [[MyParksList alloc] init];
    
    myParksList.delegate = self;
    
    [self presentPopupViewController:myParksList animationType:MJPopupViewAnimationSlideRightRight];
 
}


- (void)popUp:(AddNewPark *)popUpController

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    addNewPark           = [[AddNewPark alloc] init];
    
    addNewPark.delegate = self;
    
    [self presentPopupViewController:addNewPark animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void) popUpCar:(AddNewCar *)popUpController

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    addNewCar           = [[AddNewCar alloc] init];
    
    addNewCar.delegate  = self;
    
    [self presentPopupViewController:addNewCar animationType:MJPopupViewAnimationSlideRightRight];
    
}

- (void)popUp:(AddNewCar *)popUpController withData: (NSDictionary *) data
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    addNewCar           = [[AddNewCar alloc] init];
    
    addNewCar.delegate  = self;
    
    addNewCar.dictionary = data;
    
    [self presentPopupViewController:addNewCar animationType:MJPopupViewAnimationSlideRightRight];
  
}

- (void)popUp:(AddNewPark *)popUpController withParkData: (NSDictionary *) data
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    addNewPark           = [[AddNewPark alloc] init];
    
    addNewPark.delegate  = self;
    
    if ([data objectForKey:@"editTitle"])
    {
        addNewPark.mainTitle.text = [data objectForKey:@"editTitle"];
    }
    
    addNewPark.dictionary = data;
    
    [self presentPopupViewController:addNewPark animationType:MJPopupViewAnimationSlideRightRight];
    
}






- (void)popUpMyParks:(AddNewPark *)popUpController

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    myParksList = [[MyParksList alloc] init];
    
    myParksList.delegate = self;
    
    [self presentPopupViewController:myParksList animationType:MJPopupViewAnimationSlideRightRight];
    
}


- (void)popUpMyCars:(ShowMyCarsPopup *)popUpController

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    showMyCarsPopup = [[ShowMyCarsPopup alloc] init];
    
    showMyCarsPopup.delegate = self;
    
    [self presentPopupViewController:showMyCarsPopup animationType:MJPopupViewAnimationSlideRightRight];
    
}


- (void)popUpContactUs:(ContactUs *)popUpController

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftLeft];
    
    contactUs = [[ContactUs alloc] init];
    
    contactUs.delegate = self;
    
    [self presentPopupViewController:contactUs animationType:MJPopupViewAnimationSlideRightRight];
    
}


#pragma mark - Handle Field Methods

// touch anywhere else closes keyboard

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.view endEditing:YES];
    
}

// hide keyboard after user hit return key.

- (IBAction)hideMyKeyboard:(id)sender

{
    
    // close keyboard...
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField

{

    // if user start editing field, then show search button & radius slider
    
    [self.searchParkByAddressOutlet setHidden:NO];
     
    [self.searchParkRadiusSlider    setHidden:NO];
    
    UIView *view = self.searchParkRadiusSlider.subviews[2];
    
    CGRect frame = CGRectMake(6, 1, 28, 28);
    
    CGRect frame2 = CGRectMake(-10, 10, 58, 48);
    
    NSString *valString = [NSString stringWithFormat:@"%d", (int)self.searchParkRadiusSlider.value];
    
    val = [[UILabel alloc] initWithFrame:frame];
    
    val.text = valString;
    
    txt = [[UILabel alloc] initWithFrame:frame2];
    
    txt.text = @"ק''מ מהחניה";
    
    [txt setFont:[UIFont systemFontOfSize:10]];

    [view addSubview:txt];
    
    [view addSubview:val];
    
    firstTimeShowSlider = NO;

}


// if user finished editing field, then then remove the slider subviews

- (void)textFieldDidEndEditing:(UITextField *)textField

{
    if (textField.text.length == 0)
        
    {
        [val removeFromSuperview];
        
        [txt removeFromSuperview];
        
        [self.searchParkByAddressOutlet setHidden:YES];
        
        [self.searchParkRadiusSlider    setHidden:YES];
        
    }
    
}


// set value of slider view...

- (IBAction)radiusSliderValChanged:(id)sender

{
    
    NSString *valStr = [NSString stringWithFormat:@"%d", (int)self.searchParkRadiusSlider.value];
    
    val.text = valStr;

}



// set the basic style for window views...

- (void) setViewsDesign

{
    
    [self.searchParkByAddressOutlet setHidden:YES];
    
    [self.searchParkRadiusSlider    setHidden:YES];
    
    self.sliderVal = [NSNumber numberWithInt:25];
    
    self.searchParkByAddressField.delegate = self;
    
    CGRect frameRect =  self.searchParkByAddressField.frame;
    
    frameRect.size.height = 27;
    
    self.searchParkByAddressField.frame = frameRect;
    
}


#pragma mark - Location methods

// Get latitude & longtitude values from an address, and return relevant Coordinate

- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address

{
    
    double latitude = 0, longitude = 0;
    
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    
    if (result)
        
    {
        
        NSScanner *scanner = [NSScanner scannerWithString:result];
        
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil])
        
        {
            
            [scanner scanDouble:&latitude];
            
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil])
                
            {
                
                [scanner scanDouble:&longitude];
                
            }
            
        }
        
    }
    
    CLLocationCoordinate2D center;
    
    center.latitude = latitude;
    
    center.longitude = longitude;
    
    return center;
}


// get user location and store it in user defaults...

- (void) getUserLocation

{
    
    locationManager=[[CLLocationManager alloc] init];
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    locationManager.headingFilter = 1;
    
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
    
    NSNumber *userLat       = [NSNumber numberWithFloat:locationManager.location.coordinate.latitude];
    
    NSNumber *userLng       = [NSNumber numberWithFloat:locationManager.location.coordinate.longitude];
    
    NSNumber *defaultRadius = [NSNumber numberWithFloat:100000.0];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:userLat       forKey:kUserLat];
    
    [[NSUserDefaults standardUserDefaults] setObject:userLng       forKey:kUserLng];
    
    [[NSUserDefaults standardUserDefaults] setObject:defaultRadius forKey:kDefaultRadius];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"\n 1. latlong from get User Location: %@,%@", userLat, userLng);

}


#pragma mark - server connection methods

// get relevant parameters for server request, & return it as dictionary...

- (NSDictionary *) getParametersForServerRequestName: (NSString *) requestMethod AndSortBy: (NSString *) sortKey

{
    
    //[self hideMyKeyboard:self.searchParkByAddressField];
    
    parametersDictionary = [[NSMutableDictionary alloc] init];

    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];

    [parametersDictionary setObject:accessToken forKey:kAccessToken];
    
    
    
    
    
    if ([sortKey isEqualToString:kFavorit])
        
    {
        [parametersDictionary setObject:requestMethod forKey:kService];
        
        return parametersDictionary;
        
        NSLog(@" parameters dictionary made.");
    }
    
    NSString *latitude, *longtitude, *radius;
    
    sort = sortKey;
    
    
    // get loactions with user loaction
    
    if ([sortKey isEqualToString:kDistance])
        
    {
        latitude   = [NSString stringWithFormat:@"%@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kUserLat]];
        
        longtitude = [NSString stringWithFormat:@"%@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kUserLng]];
        
        radius     = [NSString stringWithFormat:@"%@",
                                 [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultRadius]];
        
        
        
        [parametersDictionary setObject:latitude           forKey:kLatitudeRequest];
        
        [parametersDictionary setObject:longtitude         forKey:kLongtitudeRequest];
        
        [parametersDictionary setObject:radius             forKey:kRadiusRequest];
    }
    
    // get loactions with address loaction
    
    else if ([sortKey isEqualToString:kAddressID])
        
    {
        
        latitude   = [NSString stringWithFormat:@"%f", addressGeo.latitude];
    
        longtitude = [NSString stringWithFormat:@"%f", addressGeo.longitude];
        
        radius     = val.text;
        
        [parametersDictionary setObject:latitude           forKey:kLatitudeRequest];
        
        [parametersDictionary setObject:longtitude         forKey:kLongtitudeRequest];
        
        [parametersDictionary setObject:radius             forKey:kRadiusRequest];
        
    }
    
    else NSLog(@"\n NO SORT KEY !!!!");
    
    
    NSLog(@"\n 2. latlong from get parameters for request: %@,%@", latitude, longtitude);
    
    
    // create parameters for "kGetAllParks" (map) by sddress location
    
    if ([requestMethod isEqualToString:kGetAllParks])
    
    {
        
        [parametersDictionary setObject:requestMethod forKey:kService];
        
        return parametersDictionary;
        
    }
    
    // create parameters for "searchParksForNow" (list) by user location
    
    else if ([requestMethod isEqualToString:kSearchParksForNow])
        
    {

        [parametersDictionary setObject:sortKey        forKey:kOrderByRequest];

        [parametersDictionary setObject:requestMethod      forKey:kService];
        
        return parametersDictionary;
  
    }
    
    // create parameters for "kSearchParksForReservation" (map?) by user location
    
    else if ([requestMethod isEqualToString:kSearchParksForReservation])
        
    {
        
        [parametersDictionary setObject:sortKey        forKey:kOrderByRequest];
        
        [parametersDictionary setObject:requestMethod      forKey:kService];
        
        [parametersDictionary setObject:requestMethod      forKey:kDate];
        
        [parametersDictionary setObject:requestMethod      forKey:kStartHour];
        
        [parametersDictionary setObject:requestMethod      forKey:kEndHour];
        
        return parametersDictionary;
        
    }
    
    
    return nil;
}


// get relevant data from server by base url & parameters...

- (void) getParksListWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
        {

            [self getDataFromResponse:responseObject];
        
        }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
        {
            
            NSLog(@"Error: %@", error);
            
            // ****************************************
            // * call alert to show error             *
            // ****************************************
            
        }];
    
}


// parse the response from the server & initalize the "parks" array with relevant data...

- (void) getDataFromResponse: (NSDictionary *) dataDictionary

{
    
    if (dataDictionary)
        
    {
        
        if ([[parametersDictionary objectForKey:kService] isEqualToString:kGetMyFavoriteParks])
            
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"fromFavorite" forKey:@"whichList"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            NSLog(@"\n *******  favorite parks response is:  ******* \n%@", dataDictionary);
            
            
            NSDictionary *responseDictionary = [dataDictionary objectForKey:@"message"];
            
            NSArray *allKeysArray = [[NSArray alloc] initWithArray:[responseDictionary allKeys]];
            
            NSMutableArray *parkArray = [[NSMutableArray alloc] init];
            
            for (int i=0; i<[allKeysArray count]; i++)
                
            {
                
                NSString *key = [NSString stringWithFormat:@"%d",i];
                
                NSDictionary *dic = [responseDictionary objectForKey:key];
                
                Park *park = [[Park alloc]initWithInfo:dic];
                
                [parkArray addObject:park];
                
            }
            
            self.parks = [[NSArray alloc] initWithArray:parkArray];
            
            [self openListOfRelevantParks];
            
        }
        
        
        
        
        // **************  addParkTest  ***************
        
        if ([[parametersDictionary objectForKey:kService] isEqualToString:kAddPark])
            
        {
            
            NSLog(@"\n ******* addPark response is:  ******* \n%@", dataDictionary);
            
        }
        // parse response for "getAllParks" ...
        
        if ([[parametersDictionary objectForKey:kService] isEqualToString:kGetAllParks])
            
        {
            
            NSLog(@"\n *******  getAllParks response is:  ******* \n%@", dataDictionary);
            
            
            NSDictionary *responseDictionary = [dataDictionary objectForKey:@"message"];
            
            NSArray *allKeysArray = [[NSArray alloc] initWithArray:[responseDictionary allKeys]];
            
            NSMutableArray *parkArray = [[NSMutableArray alloc] init];
            
            for (int i=0; i<[allKeysArray count]; i++)
                
            {
                
                NSString *key = [NSString stringWithFormat:@"%d",i];
                
                NSDictionary *dic = [responseDictionary objectForKey:key];
                
                Park *park = [[Park alloc]initWithInfo:dic];
                
                [parkArray addObject:park];
                
            }
            
            self.parks = [[NSArray alloc] initWithArray:parkArray];
            
            [self openListOfRelevantParks];
        }
        
        else if ([[parametersDictionary objectForKey:kService] isEqualToString:kSearchParksForNow]
                 && [sort isEqualToString:kDistance])
            
        {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"homeScreen" forKey:@"whichList" ];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"\n *******  search parks for now (user loc') response is:  ******* \n%@", dataDictionary);
           
            NSDictionary *responseDictionary = [dataDictionary objectForKey:@"message"];
            
            NSArray *allKeysArray = [[NSArray alloc] initWithArray:[responseDictionary allKeys]];
            
            NSMutableArray *parkArray = [[NSMutableArray alloc] init];
            
            for (int i=0; i<[allKeysArray count]; i++)
                
            {
                
                NSString *key = [NSString stringWithFormat:@"%d",i];
                
                NSDictionary *dic = [responseDictionary objectForKey:key];
                
                Park *park = [[Park alloc]initWithInfo:dic];
                
                [parkArray addObject:park];
                
            }
            
            self.parks = [[NSArray alloc] initWithArray:parkArray];
            
            [self openListOfRelevantParks];
            
        }
        
        else if ([[parametersDictionary objectForKey:kService] isEqualToString:kSearchParksForNow]
                 && [sort isEqualToString:kAddressID])
            
        {
            
            NSLog(@"\n *******  search parks for now (address) response is:  ******* \n%@", dataDictionary);
            
            NSDictionary *responseDictionary = [dataDictionary objectForKey:@"message"];
            
            NSArray *allKeysArray = [[NSArray alloc] initWithArray:[responseDictionary allKeys]];
            
            NSMutableArray *parkArray = [[NSMutableArray alloc] init];
            
            for (int i=0; i<[allKeysArray count]; i++)
                
            {
                
                NSString *key = [NSString stringWithFormat:@"%d",i];
                
                NSDictionary *dic = [responseDictionary objectForKey:key];
                
                Park *park = [[Park alloc]initWithInfo:dic];
                
                [parkArray addObject:park];
                
            }
            
            self.parks = [[NSArray alloc] initWithArray:parkArray];
            
            [self showRelevantParksOnMap];
            
        }

    }
   
}



#pragma mark - Delegate methods

#pragma mark - Public methods

#pragma mark - Setter methods

#pragma mark - IBAction methods



@end
