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
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    
    NSArray *array = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userId context:context];
    if ( array ) {
        self.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
    }
    
    
    PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
    __weak PAMPartiesTableViewController *weakSelf = self;
    [partyMakerAPI partiesWithCreatorId:@(userId) callback:^(NSDictionary *response, NSError *error) {
        NSArray *array = [response objectForKey:@"response"];
        if(![array isEqual:[NSNull null]]) {
            NSLog(@"response = %@",response);
            [self addPartiesFromServerToCoreData:array];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];

}

- (void) addPartiesFromServerToCoreData:(NSArray *) serverParty {
    [[PAMDataStore standartDataStore] deleteAllParties];
    for (id serverPary in serverParty) {
        [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
            PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:backgroundContext];
            partyCore.partyId = [[serverPary objectForKey:@"id"] longLongValue];
            partyCore.name = [serverPary objectForKey:@"name"];
            partyCore.partyDescription = [serverPary objectForKey:@"comment"];
            partyCore.partyType = [[serverPary objectForKey:@"logo_id"] longLongValue];
            partyCore.startDate = [[serverPary objectForKey:@"start_time"] longLongValue];
            partyCore.endDate = [[serverPary objectForKey:@"end_time"] longLongValue];
        } completion:^{
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *array = [[PAMDataStore standartDataStore] fetchAllParties];
    if ( array ) {
        self.arrayWithParties = [[NSMutableArray alloc] initWithArray:array];
    }
    [self.tableView reloadData];
}

/*- (void)viewWillAppear:(BOOL)animated {
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
    __weak PAMPartiesTableViewController *weakSelf = self;
    [partyMakerAPI partiesWithCreatorId:@(userId) callback:^(NSDictionary *response, NSError *error) {
        if(![response objectForKey:@"response"]) {
            NSLog(@"response = %@",response);
            //weakSelf.arrayWithParties = [[NSMutableArray alloc] initWithArray:[response objectForKey:@"response"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}*/

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
    
    NSString *strWithDate = [NSString stringWithFormat:@"%@     %@ - %@", [NSString stringPrityDateWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]],
                                                               [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]],
                                                               [NSString stringHourAndMinutesWithDate:[NSDate dateWithTimeIntervalSince1970:party.endDate]]];
    [cell configureWithPartyName:party.name
                       partyDate:strWithDate
                       partyType:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%lld", party.partyType]]];

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
        NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        showView.party = [self.arrayWithParties objectAtIndex:selectedRow];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
