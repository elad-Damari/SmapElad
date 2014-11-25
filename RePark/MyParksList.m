//
//  MyParksList.m
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "MyParksList.h"
#import "UIViewController+MJPopupViewController.h"
#import "PXAlertView+Customization.h"
#import <MessageUI/MessageUI.h>
#import "MyParksCell.h"
#import "AppDelegate.h"

@interface MyParksList ()
{
    AppDelegate *appDelegate;
}


- (IBAction)newPark:(id)sender;



@end

@implementation MyParksList

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSDictionary *parameters = [self getParametersForRequest:kDistance];
    
    [self getCarsListWithRequestUrl:kServerAdrress andParameters:parameters];
    
}


#pragma mark - TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.list count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return 158;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyParksCell *cell = [tableView dequeueReusableCellWithIdentifier:@"parkCell"];
    
    if (!cell)
        
    {
        
        [tableView registerNib:[UINib nibWithNibName:@"MyParksCell" bundle:nil]
        forCellReuseIdentifier:@"parkCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"parkCell"];
        
        Park *park = [self.list objectAtIndex:indexPath.row];
        
        NSString *taken = [NSString stringWithFormat:@"%@", park.isTakenNow];
        
        if ([taken isEqualToString:@"1"])
            
        {
            
            Car *car = [_carList objectAtIndex:indexPath.row];
            
            
            
            cell.carIdLabel.text = car.carNumber;
            
            NSString *type = [NSString stringWithFormat:@"%@", car.carTypeID];
            
            int typeNumber = [type intValue];
            
            cell.carNumberLabel.text = [[appDelegate.dataBase objectForKey:kCarTypeID]
                                        objectAtIndex:typeNumber];
            
            NSString *color = [NSString stringWithFormat:@"%@", car.carColorID];
            
            int colorNumber = [color intValue];
            
            cell.carTypeLabel.text = [[appDelegate.dataBase objectForKey:kCarColorID]
                                           objectAtIndex:colorNumber];
            
        }
        
        [cell configureCellWithMyPark:park];
        
        return cell;
        
    }
    
    Park *park = [self.list objectAtIndex:indexPath.row];
    
    NSString *taken = [NSString stringWithFormat:@"%@", park.isTakenNow];
    
    NSLog(@" taken status is: %@", park.isTakenNow);
    
    if ([taken isEqualToString:@"1"])
        
    {
        
        Car *car = [_carList objectAtIndex:indexPath.row];
        
        cell.carIdLabel.text = car.carNumber;
        
        NSString *type = [NSString stringWithFormat:@"%@", car.carTypeID];
        
        int typeNumber = [type intValue];
        
        cell.carNumberLabel.text = [[appDelegate.dataBase objectForKey:kCarTypeID]
                                    objectAtIndex:typeNumber];
        
        NSString *color = [NSString stringWithFormat:@"%@", car.carColorID];
        
        int colorNumber = [color intValue];
        
        cell.carTypeLabel.text = [[appDelegate.dataBase objectForKey:kCarColorID]
                                    objectAtIndex:colorNumber];
        
    }
    
    [cell configureCellWithMyPark:park];
    
    return cell;
    
}


#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    Park *park = [self.list    objectAtIndex:indexPath.row];
    
    Car  *car  = [self.carList objectAtIndex:indexPath.row];
    
    [self.delegate popUp:self clickedMyPark:park withCar:car];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





- (NSDictionary *) getParametersForRequest: (NSString *) sortKey

{
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:accessToken        forKey:kAccessToken];
    
    [dic setObject:kGetMyParks        forKey:kService];
    
    return dic;
    
}

- (void) getCarsListWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:kServerAdrress parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         NSLog(@"JSON: %@", responseObject);
         
         [self getDataFromResponse:responseObject];
         
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}

- (void) getDataFromResponse: (NSDictionary *) dataDictionary

{
    
    if (dataDictionary)
        
    {
        
        NSDictionary *responseDictionary = [dataDictionary objectForKey:@"message"];
        
        NSArray *allKeysArray = [[NSArray alloc] initWithArray:[responseDictionary allKeys]];
        
        NSMutableArray *parksArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *carsArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[allKeysArray count]; i++)
            
        {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSDictionary *dic = [responseDictionary objectForKey:key];
            
            Park *park = [[Park alloc]initWithInfo:dic];
            
            Car  *car  = [[Car  alloc]initWithInfo:dic];
            
            if ([car.carNumber isKindOfClass:[NSNull class]])
                
            {
              
                park.isTakenNow = @"0";
                
            }
            
            else
            {
                park.isTakenNow = @"1";
            }
            
            [carsArray addObject:car];
            
            [parksArray addObject:park];
            
        }
        
        _carList = [[NSArray alloc] initWithArray:carsArray];
        
        _list    = [[NSArray alloc] initWithArray:parksArray];
        
        [_myParksTableView reloadData];
        
    }
    
    
}


- (IBAction)closeButton:(id)sender

{

    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}

- (IBAction)sendMessage:(id)sender

{
    NSLog(@" sendMessage ");
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"פניה לשירות לקוחות"
                                                 message:@"כיצד ברצונך ליצור עימנו קשר?"
                                             cancelTitle:@"מייל"
                                              otherTitle:@"חייג"
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                if (buttonIndex == 0)
                                                  {
                                                      NSLog(@"Cancel (Blue) button pressed %ld", (long)buttonIndex);
                                                      
                                                      // Email Subject
                                                      NSString *emailTitle = @"פניה לשירות לקוחות";
                                                      // Email Content
                                                      NSString *messageBody = @"אנא צרו איתי קשר לגבי הנושאים הבאים:";
                                                      // To address
                                                      NSArray *toRecipents = [NSArray arrayWithObject:@"elad.navigazo@gmail.com"];
                                                      
                                                      MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
                                                      mc.mailComposeDelegate = self;
                                                      [mc setSubject:emailTitle];
                                                      [mc setMessageBody:messageBody isHTML:NO];
                                                      [mc setToRecipients:toRecipents];
                                                      
                                                      // Present mail view controller on screen
                                                      [self presentViewController:mc animated:YES completion:NULL];

                                                      [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                                      
                                                      
                                                  }
                                                  else if (buttonIndex == 1)
                                                  {
                                                      NSLog(@"Other (Red) button pressed %ld", (long)buttonIndex);
                                                      NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",
                                                                               [[NSUserDefaults standardUserDefaults] objectForKey:@"costumerSupportNumber"]];
                                                      
                                                      [[UIApplication sharedApplication] openURL:
                                                       [NSURL URLWithString:phoneNumber]];
                                                      
                                                      [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
                                                  }
                                                  
                                                  
                                              }];
    
    [alert setCancelButtonBackgroundColor:[UIColor lightGrayColor]];
    [alert setOtherButtonBackgroundColor:[UIColor lightGrayColor]];
    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSelector:@selector(closeButton:) withObject:nil afterDelay:0.05];
}


- (IBAction)watchOnMap:(id)sender

{
    
     NSLog(@" watchOnMap ");
    
    // will be implemented by nadav...
    
    
}


- (IBAction)myParkDetails:(id)sender

{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_myParksTableView];
    NSIndexPath *indexPath = [_myParksTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
        
    {
    
        Park *park = [self.list    objectAtIndex:indexPath.row];
    
        Car  *car  = [self.carList objectAtIndex:indexPath.row];
    
        [self.delegate popUp:self clickedMyPark:park withCar:car];
        
    }
    
    
}


- (IBAction)enableOrDisableMyPark:(id)sender

{
    
     NSLog(@" enableOrDisableMyPark ");
    
    // wait for missing fields from server
    
    
}



- (IBAction)newPark:(id)sender

{

    [self.delegate popUp:self];

}











@end
