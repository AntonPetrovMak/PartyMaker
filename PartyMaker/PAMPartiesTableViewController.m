///
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    self.arrayWithParties = [[NSMutableArray alloc] init];
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(upDateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    NSArray *array = [PAMPartyCore fetchPartiesByUserId:userId context:context];
    if ( array ) {
        self.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
        for (PAMPartyCore *party in self.arrayWithParties) {
            [PAMLocalNotification notificationForRarty:party];
        }
    }
}

- (void)addPartiesFromServerToCoreData:(NSArray *) serverParty {
    for (id party in serverParty) {
        [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
            PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:backgroundContext];
            partyCore.partyId = [[party objectForKey:@"id"] longLongValue];
            partyCore.name = [party objectForKey:@"name"];
            partyCore.partyDescription = [party objectForKey:@"comment"];
            partyCore.partyType = [[party objectForKey:@"logo_id"] longLongValue];
            partyCore.startDate = [[party objectForKey:@"start_time"] longLongValue];
            partyCore.endDate = [[party objectForKey:@"end_time"] longLongValue];
            partyCore.longitude = [party objectForKey:@"longitude"];
            partyCore.latitude = [NSString removeEscapeSpecialCharactersWithString:[party objectForKey:@"latitude"]];
            NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
            PAMUserCore *userCore = (PAMUserCore *)[PAMUserCore fetchUserByUserId:userId context:backgroundContext];
            partyCore.creatorParty = userCore;
        } completion:^{
            
        }];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self upDateTable];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Reachability

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    if([self.wifiReachability currentReachabilityStatus] == ReachableViaWiFi) {
        NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
        [[PAMDataStore standartDataStore] upDateOfflinePartiesByUserId:userId];
    }
}

- (void)reachabilityChanged:(NSNotification *) notification {
    if([self.wifiReachability currentReachabilityStatus] == ReachableViaWiFi) {
        NSLog(@"INTERNET IS OK");
        NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
        [[PAMDataStore standartDataStore] upDateOfflinePartiesByUserId:userId];
        [[PAMDataStore standartDataStore] upDatePartyByUserId:userId];
        [self.tableView reloadData];
    } else {
        NSLog(@"NO INTERNET");
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Helpers
- (void)upDateTable {
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    NSArray *array = [PAMPartyCore fetchPartiesByUserId:userId context:context];
    if ( array ) {
        self.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
    }
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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
    PAMPartyCore *party = [self.arrayWithParties objectAtIndex:indexPath.row];
    
    NSString *strWithDate = [NSString stringWithFormat:@"%@     %@ - %@", [NSString stringPrityDateWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]],
                                                               [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]],
                                                               [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:party.endDate]]];
    [cell configureWithPartyName:party.name
                       partyDate:strWithDate
                       partyType:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%lld", party.partyType]]
                    partyAddress:party.latitude];
    if(!party.latitude.length) {
        [cell.partyDateLabel setTextColor:[UIColor colorWithRed:98/255.f green:105/255.f blue:119/255.f alpha:1]];
    }
    return cell;
}


#pragma mark - UITableViewDataSource

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueShowParty"]) {
        PAMShowPartyViewController *showView = [segue destinationViewController];
        NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        showView.party = [self.arrayWithParties objectAtIndex:selectedRow];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
