//
//  MJPopUpController.m
//  ViewControllerDemo
//
//  Created by Nadav Kershner on 11/7/14.
//  Copyright (c) 2014 Nadav. All rights reserved.
//

#import "MJPopUpController.h"

@interface MJPopUpController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MJPopUpController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)cancel:(id)sender{


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.list count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.textLabel.text = self.list[indexPath.row];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.delegate popUp:self clickedRowAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
