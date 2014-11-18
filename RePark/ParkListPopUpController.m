//
//  ParkListPopUpController.m
//  RePark
//
//  Created by Elad Damari on 11/9/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ParkListPopUpController.h"
#import "ParkListCell.h"
#import "UIViewController+MJPopupViewController.h"
#import "ParkDetailPopUp.h"

@interface ParkListPopUpController ()

@property (weak, nonatomic) IBOutlet UIButton *sortByDistanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *sortByPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong)   UIRefreshControl *refreshControl;

- (IBAction)sortByPriceButton:(id)sender;

- (IBAction)sortByDistanceButton:(id)sender;

- (IBAction)okButton:(id)sender;

@end


@implementation ParkListPopUpController


- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    _titleLabel.hidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"whichList"] isEqualToString:@"fromFavorite"])
    {
       
        _sortByDistanceLabel.enabled         = NO;
        _sortByDistanceLabel.titleLabel.text = @"";
        _sortByPriceLabel.enabled            = NO;
        _sortByPriceLabel.titleLabel.text    = @"";
        
        _titleLabel.hidden = NO;
        
    }
    else
    {

        _sortByDistanceLabel.enabled         = YES;
        _sortByDistanceLabel.titleLabel.text = @"סדר לפי מרחק";
        _sortByPriceLabel.enabled            = YES;
        _sortByPriceLabel.titleLabel.text    = @"סדר לפי מחיר";
    }
        
    
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //refreshControl.backgroundColor = [UIColor lightGrayColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    refreshControl.tintColor = [UIColor purpleColor];
    [refreshControl addTarget:self action:@selector(refresh:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

 
}


- (void)refresh:(UIRefreshControl *)refreshControl
{
    [self sortByDistanceButton:nil];
    
    //[self.tableView reloadData];
    
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
    
    [self.delegate popUp:self clickedPark:park];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) reloadList

{
    
    NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
    
    NSDictionary *parameters = [self getParametersForRequest:kDistance];
    
    [self getParksListWithRequestUrl:requestUrl andParameters:parameters];
    
}

#pragma mark - IBAction methods

- (IBAction)sortByPriceButton:(id)sender
{
    NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
    
    NSDictionary *parameters = [self getParametersForRequest:kPricePerDayRequest];
    
    [self getParksListWithRequestUrl:requestUrl andParameters:parameters];
}

- (IBAction)sortByDistanceButton:(id)sender
{
    NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
    
    NSDictionary *parameters = [self getParametersForRequest:kDistance];
    
    [self getParksListWithRequestUrl:requestUrl andParameters:parameters];
}

- (IBAction)okButton:(id)sender // close list with no selection...
{
     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
}

- (IBAction)addToFavorite:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Park *mypark = [self.list objectAtIndex:indexPath.row];
        if ([mypark.favorit isEqualToString:@"0"])
        {
            mypark.favorit = @"1";
            
            //**************
            
            NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
            
            //params dic
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
            
            [dic setObject:accessToken        forKey:kAccessToken];
            
            [dic setObject:kAddToFavorite     forKey:kService];
            
            [dic setObject:mypark.parkID   forKey:kParkToFavorites];

            [self addToFavoriteWithRequestUrl:requestUrl andParameters:dic];
            
            //********************

        }
        else
        {
            
            mypark.favorit = @"0";
            
            NSString     *requestUrl = [NSString stringWithFormat:@"%@", kServerAdrress];
            
            //params dic
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            
            NSString *accessToken = [NSString stringWithFormat:@"%@",
                                     [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
            
            [dic setObject:accessToken        forKey:kAccessToken];
            
            [dic setObject:kDelFromFavorite   forKey:kService];
            
            [dic setObject:mypark.parkID      forKey:kParkToDelFromFavorites];
            
            [self addToFavoriteWithRequestUrl:requestUrl andParameters:dic];
            
            //mypark.favorit = @"0";

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
         
         //NSLog(@"JSON: %@", responseObject);
         
         [self getDataFromResponse:responseObject];
         
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
        
        [self.tableView beginUpdates];
        
        self.list = [[NSArray alloc] initWithArray:parkArray];
        
        NSLog(@"\n *** count : %lu",(unsigned long)[parkArray count]);
        
        [self.tableView reloadData];
        
        [self.tableView endUpdates];
        
    }
    
    
}




#pragma mark - Delegate methods
#pragma mark - IBAction methods
#pragma mark - Public methods

#pragma mark - Setter methods
@end
