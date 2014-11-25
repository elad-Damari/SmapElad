//
//  ShowMyCarsPopup.m
//  RePark
//
//  Created by Elad Damari on 11/17/14.
//  Copyright (c) 2014 Nadav Kershner. All rights reserved.
//

#import "ShowMyCarsPopup.h"
#import "AFNetworking.h"
#import "UIViewController+MJPopupViewController.h"
#import "CarListCellTableViewCell.h"
#import "Car.h"


@interface ShowMyCarsPopup ()

@property (weak, nonatomic) IBOutlet UITableView *carsTableView;

- (IBAction)closeButton:(id)sender;

- (IBAction)addNewCarButton:(id)sender;




@end

@implementation ShowMyCarsPopup


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *parameters = [self getParametersForRequest:kGetMyCars];
    
    [self getCarsListWithRequestUrl:kServerAdrress andParameters:parameters];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)setAsDefaultCar:(id)sender

{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.carsTableView];
    
    NSIndexPath *indexPath = [self.carsTableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil)
        
    {
        
        Car *car = [self.list objectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject:car.carID forKey:@"defaultCarId"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    [self.carsTableView reloadData];

}

- (IBAction)editCarProperties:(id)sender

{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.carsTableView];
    
    NSIndexPath *indexPath = [self.carsTableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil)
        
    {
        
        Car *car = [self.list objectAtIndex:indexPath.row];
    
        NSLog(@"\n go to edit car properties window with car ID: %@", car.carID);
    
    }
    
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
    
    return 140;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"parkCell"];
    
    if (!cell)
        
    {
        
        [tableView registerNib:[UINib nibWithNibName:@"CarListCellTableViewCell" bundle:nil]
        forCellReuseIdentifier:@"parkCell"];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"parkCell"];
        
        Car *car = [self.list objectAtIndex:indexPath.row];
        
        [cell configureCellWithCar:car];
        
        
    }
    
    Car *car = [self.list objectAtIndex:indexPath.row];
    
    [cell configureCellWithCar:car];
    
    return cell;
    
}


#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    Car *car = [self.list objectAtIndex:indexPath.row];
    
    NSLog(@"car is: %@", car.carNumber);
    
    //[self.delegate popUp:self clickedPark:park];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSDictionary *) getParametersForRequest: (NSString *) sortKey

{
    
    NSString *accessToken = [NSString stringWithFormat:@"%@",
                             [[NSUserDefaults standardUserDefaults] objectForKey:kAccessToken]];
    
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:accessToken        forKey:kAccessToken];
    
    [dic setObject:kGetMyCars         forKey:kService];
    
    return dic;
    
}

- (void) getCarsListWithRequestUrl:(NSString *) requestUrl andParameters:(NSDictionary *) parameters

{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     
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
        
        NSMutableArray *carsArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[allKeysArray count]; i++)
            
        {
            
            NSString *key = [NSString stringWithFormat:@"%d",i];
            
            NSDictionary *dic = [responseDictionary objectForKey:key];
            
            Car *car = [[Car alloc]initWithInfo:dic];
            
            [carsArray addObject:car];
            
        }
        
        _list =  [[NSArray alloc] initWithArray:carsArray];
        
        [_carsTableView reloadData];
        
    }
    
    
}


- (IBAction)closeButton:(id)sender

{
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideRightRight];
    
}

- (IBAction)addNewCarButton:(id)sender

{
    
    [self.delegate popUpCar:self];
    
}








@end
