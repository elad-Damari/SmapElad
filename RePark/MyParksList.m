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

@interface MyParksList ()


@end

@implementation MyParksList

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
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
        
        [cell configureCellWithMyPark:park];
        
        
    }
    
    Park *park = [self.list objectAtIndex:indexPath.row];
    
    [cell configureCellWithMyPark:park];
    
    return cell;
    
}


#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    Park *park = [self.list objectAtIndex:indexPath.row];
    
    NSLog(@"park is: %@", park.parkID);
    
    //[self.delegate popUp:self clickedPark:park];
    
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
        
        for (int i=0; i<[allKeysArray count]; i++)
            
        {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSDictionary *dic = [responseDictionary objectForKey:key];
            
            Park *park = [[Park alloc]initWithInfo:dic];
            
            [parksArray addObject:park];
            
        }
        
        _list =  [[NSArray alloc] initWithArray:parksArray];
        
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
                                                  if (cancelled)
                                                  {
                                                      NSLog(@"Cancel (Blue) button pressed");
                                                      
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

                                                      
                                                      
                                                      
                                                  }
                                                  else
                                                  {
                                                      NSLog(@"Other (Red) button pressed");
                                                      NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@",
                                                                               [[NSUserDefaults standardUserDefaults] objectForKey:@"costumerSupportNumber"]];
                                                      
                                                      [[UIApplication sharedApplication] openURL:
                                                       [NSURL URLWithString:phoneNumber]];
                                                  }
                                                  
                                                  [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
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
    
     NSLog(@" myParkDetails ");
    
    // wait for missing fields from server
    
    
}


- (IBAction)enableOrDisableMyPark:(id)sender

{
    
     NSLog(@" enableOrDisableMyPark ");
    
    // wait for missing fields from server
    
    
}










@end
