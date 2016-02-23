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
    NSArray *array = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userId context:context];
    if ( array ) {
        self.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
    }
}

- (void)addPartiesFromServerToCoreData:(NSArray *) serverParty {
    for (id serverPary in serverParty) {
        [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
            PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:backgroundContext];
            partyCore.partyId = [[serverPary objectForKey:@"id"] longLongValue];
            partyCore.name = [serverPary objectForKey:@"name"];
            partyCore.partyDescription = [serverPary objectForKey:@"comment"];
            partyCore.partyType = [[serverPary objectForKey:@"logo_id"] longLongValue];
            partyCore.startDate = [[serverPary objectForKey:@"start_time"] longLongValue];
            partyCore.endDate = [[serverPary objectForKey:@"end_time"] longLongValue];
            NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
            PAMUserCore *userCore = (PAMUserCore *)[[PAMDataStore standartDataStore] fetchUserByUserId:userId context:backgroundContext];
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
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    NSArray *array = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userId context:context];
    if ( array ) {
        self.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
    }
    [self.tableView reloadData];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Reachability

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if([self.wifiReachability currentReachabilityStatus] == ReachableViaWiFi) {
        NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
        [[PAMDataStore standartDataStore] upDateOfflinePartiesByUserId:userId];
    }
}

-(void) reachabilityChanged:(NSNotification *) notification {
    if([self.wifiReachability currentReachabilityStatus] == ReachableViaWiFi) {
        NSLog(@"Ok");
        NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
        [[PAMDataStore standartDataStore] upDateOfflinePartiesByUserId:userId];
        [self.tableView reloadData];
    } else {
        
        NSLog(@"Neok");
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - Helpers
- (void)upDateTable {
    if([self.wifiReachability currentReachabilityStatus] == ReachableViaWiFi) {
        NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
        PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
        __weak PAMPartiesTableViewController *weakSelf = self;
        [partyMakerAPI partiesWithCreatorId:@(userId) callback:^(NSDictionary *response, NSError *error) {
            //NSLog(@"response = %@",response);
            if([response objectForKey:@"response"]) {
                NSArray *array = [response objectForKey:@"response"];
                if(![array isEqual:[NSNull null]]){
                    [[PAMDataStore standartDataStore] clearPartiesByUserId:userId];
                    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
                    [[PAMDataStore standartDataStore] addPartiesFromServerToCoreData:array byCreatorPartyId:userId completion:^{
                        NSArray *array = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userId context:context];
                        if ( array ) {
                            weakSelf.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
                        }
                    }];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.refreshControl endRefreshing];
            });
        }];
    } else {
        [self.refreshControl endRefreshing];
    }
}

#pragma mark - Action
- (IBAction)logOffUser:(UIBarButtonItem *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    UITabBarController *tabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"PAMLoginViewController"];
    [self presentViewController:tabBar animated:YES completion:nil];
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
    
    NSString *strWithDate = [NSString stringWithFormat:@"%@     %@ - %@ id: %lld", [NSString stringPrityDateWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]],
                                                               [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]],
                                                               [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:party.endDate]],
                                                                party.partyId];
    [cell configureWithPartyName:party.name
                       partyDate:strWithDate
                       partyType:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%lld", party.partyType]]];

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
