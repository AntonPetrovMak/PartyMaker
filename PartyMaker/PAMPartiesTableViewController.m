//
//  PAMPartiesTableViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartiesTableViewController.h"

@interface PAMPartiesTableViewController ()

@property(strong,nonatomic) NSMutableArray *arrayWithParties;

@end

@implementation PAMPartiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayWithParties = [[NSMutableArray alloc] init];
    //load date from code data
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    //load new data from code data + add + delete + edit 
    [self.tableView reloadData];
}

/*- (void)viewWillAppear:(BOOL)animated {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    PAMUser *user = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    PAMPartyMakerSDK *partyMakerSDK = [PAMPartyMakerSDK standartPartyMakerSDK];
    __weak PAMPartiesTableViewController *weakSelf = self;
    [partyMakerSDK partiesWithCreatorId:@(user.userId) callback:^(NSDictionary *response, NSError *error) {

        if(![response objectForKey:@"response"]) {
            weakSelf.arrayWithParties = [[NSMutableArray alloc] initWithArray:[response objectForKey:@"response"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    }];
}*/

#pragma mark - Action
- (IBAction)logOffUser:(UIBarButtonItem *)sender {
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
//    UITabBarController *tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"PAMLoginViewController"];
//    [self presentViewController:tabBar animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWithParties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PAMPartyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[PAMPartyTableCell reuseIdentifire]];
    if(!cell) {
        cell = [[PAMPartyTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:[PAMPartyTableCell reuseIdentifire]];
    }
    PAMParty *party = [self.arrayWithParties objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    
    [cell configureWithPartyName:party.partyName
                       partyDate:[dateFormatter stringFromDate:[party.partyStartDate dateByAddingTimeInterval:-7200]]
                       partyType:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)party.partyType]]];
    return cell;
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PAMPartyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[PAMPartyTableCell reuseIdentifire]];
    if(!cell) {
        cell = [[PAMPartyTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:[PAMPartyTableCell reuseIdentifire]];
    }

    //PAMParty *party = [[[PAMDataStore standartDataStore] arrayWithParties] objectAtIndex:indexPath.row];
    NSDictionary *dictionaty = [self.arrayWithParties objectAtIndex:indexPath.row];
    PAMParty *party = [[PAMParty alloc] initWithPartyId:[[dictionaty objectForKey:@"id"] integerValue]
                                                   name:[dictionaty objectForKey:@"name"]
                                              startDate:[NSString getHumanDate:[dictionaty objectForKey:@"start_time"]]
                                                endDate:[NSString getHumanDate:[dictionaty objectForKey:@"end_time"]]
                                               paryType:[[dictionaty objectForKey:@"logo_id"] integerValue]
                                            description:[dictionaty objectForKey:@"comment"]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
  
    [cell configureWithPartyName:party.partyName
                       partyDate:[dateFormatter stringFromDate:[party.partyStartDate dateByAddingTimeInterval:-7200]]
                       partyType:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)party.partyType]]];
    return cell;
}*/

#pragma mark - UITableViewDataSource

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueShowParty"]) {
        PAMShowPartyViewController *showView = [segue destinationViewController];
        PAMParty *party = [[[PAMDataStore standartDataStore] arrayWithParties] objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        showView.party = party;
        showView.indexCurrentCell = [self.tableView indexPathForSelectedRow].row;
        showView.tableViewWithPaties = self.tableView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
