//
//  ParkResrvationListPopup.m
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkResrvationListPopup.h"
#import "UIViewController+MJPopupViewController.h"
#import "ParkListCell.h"

@interface ParkResrvationListPopup ()

- (IBAction)sortByDistance:(id)sender;

- (IBAction)sortByPrice:(id)sender;

- (IBAction)closeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *parksTableView;

@end

@implementation ParkResrvationListPopup

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    refreshControl.tintColor = [UIColor purpleColor];
    [refreshControl addTarget:self action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.parksTableView addSubview:refreshControl];

}

- (void)refresh:(UIRefreshControl *)refreshControl

{
    
    [self sortByDistance:nil];
    
    [refreshControl endRefreshing];
    
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
    
    return 130;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ParkListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"parkCell"];
    
    if (!cell)
        
    {
        
        [tableView registerNib:[UINib nibWithNibName:@"ParkListCell" bundle:nil]
        forCellReuseIdentifier:@"parkCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"parkCell"];
        
        Park *park = [self.list objectAtIndex:indexPath.row];
        
        [cell configureCellWithPark:park];
        
    }
    
    Park *park = [self.list objectAtIndex:indexPath.row];
    
    [cell configureCellWithPark:park];
    
    return cell;
    
}


#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    Park *park = [self.list objectAtIndex:indexPath.row];
    
    NSLog(@"park; %@", park.parkComments);
    
    //check if user is register with car & payment info ...
    
    if ([self isUserTypeOK])
    {
        [self.delegate popUp:self clickedParkReservation:park
                                                withDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"reservationDate"]
                                               startTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"reservationStart"]
                                              andEndTime:[[NSUserDefaults standardUserDefaults] objectForKey:@"reservationEnd"]];
    }
    
    else
    {
        // ****************************************
        // * call alert and update the user...    *
        // * with option to go to registration... *
        // ****************************************
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) reloadList

{
    NSDictionary *parameters = [self getParametersForRequest:kDistance];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
}



- (IBAction)sortByDistance:(id)sender

{
    
    NSDictionary *parameters = [self getParametersForRequest:kPricePerDayRequest];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
}

- (IBAction)sortByPrice:(id)sender

{
    
    NSDictionary *parameters = [self getParametersForRequest:kDistance];
    
    [self getParksListWithRequestUrl:kServerAdrress andParameters:parameters];
    
}

- (IBAction)closeButton:(id)sender

{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}


- (IBAction)addToFavorite:(UIButton *)sender
{
    //[sender addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.parksTableView];
    NSIndexPath *indexPath = [self.parksTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Park *mypark = [self.list objectAtIndex:indexPath.row];
        if ([mypark.favorit isEqualToString:@"0"])
        {
 
            mypark.favorit = @"1";
            
            NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
 
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
            
            [dic setObject:accessToken        forKey:kAccessToken];
            
            [dic setObject:kAddToFavorite     forKey:kService];
            
            [dic setObject:mypark.parkID   forKey:kParkToFavorites];
            
            [self addToFavoriteWithRequestUrl:requestUrl andParameters:dic];

        }
        else
        {
            
            mypark.favorit = @"0";

            NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];

            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
            
            [dic setObject:accessToken        forKey:kAccessToken];
            
            [dic setObject:kDelFromFavorite   forKey:kService];
            
            [dic setObject:mypark.parkID      forKey:kParkToDelFromFavorites];
            
            [self addToFavoriteWithRequestUrl:requestUrl andParameters:dic];
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.list];
        [arr replaceObjectAtIndex:indexPath.row withObject:mypark];
        self.list = [[NSArray alloc] initWithArray:arr];
        
        mypark = [self.list objectAtIndex:indexPath.row];
        
        
    }
    
}


#pragma mark - Private methods

- (NSDictionary *) getParametersForRequest: (NSString *) sortKey

{
    
    NSString *latitude    = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kUserLat]];
    
    NSString *longtitude  = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kUserLng]];
    
    NSString *radius      = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultRadius]];
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:latitude           forKey:kLatitudeRequest];
    
    [dic setObject:longtitude         forKey:kLongtitudeRequest];
    
    [dic setObject:radius             forKey:kRadiusRequest];
    
    [dic setObject:accessToken        forKey:kAccessToken];
    
    [dic setObject:sortKey            forKey:kOrderByRequest];
    
    [dic setObject:kSearchParksForNow forKey:kService];
    
    return dic;
    
}

- (void) getParksListWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {

         [self getDataFromResponse:responseObject];
         
         NSString *response = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
         NSLog(@"response: %@", response);
         
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     
     {
         
         NSLog(@"Error: %@", error);
         
     }];
    
}

- (void) addToFavoriteWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
     {
         
         NSString *response = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
         NSLog(@"response: %@", response);

         
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
        
        NSMutableArray *parkArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[allKeysArray count]; i++)
            
        {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSDictionary *dic = [responseDictionary objectForKey:key];
            
            Park *park = [[Park alloc]initWithInfo:dic];
            
            [parkArray addObject:park];
            
        }
        
        self.list = [[NSArray alloc] initWithArray:parkArray];
        
        //[self.parksTableView beginUpdates];
        
        
        
        NSLog(@"\n *** count : %lu",(unsigned long)[parkArray count]);
        
        [self.parksTableView reloadData];
        
        //[self.parksTableView endUpdates];
        
    }
    
    
}

 - (BOOL) isUserTypeOK

{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] isEqualToString:@"11"])
    {
            return YES;
    }
    
    else return NO;
}




@end
