//
//  PAMPartiesTableViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartiesTableViewController.h"

@interface PAMPartiesTableViewController ()

@end

@implementation PAMPartiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[PAMDataStore standartDataStore] arrayWithParties] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PAMPartyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[PAMPartyTableCell reuseIdentifire]];
    if(!cell) {
        cell = [[PAMPartyTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:[PAMPartyTableCell reuseIdentifire]];
    }

    PAMParty *party = [[[PAMDataStore standartDataStore] arrayWithParties] objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy hh:mm"];
  
    [cell configureWithPartyName:party.partyName
                       partyDate:[dateFormatter stringFromDate:party.partyStartDate]
                       partyType:[UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", party.partyType]]];
    return cell;
}

#pragma mark - UITableViewDataSource

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"touch on row %ld", indexPath.row);
}


@end
