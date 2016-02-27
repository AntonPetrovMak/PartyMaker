//
//  PAMUsersTableViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 26.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMUsersTableViewController.h"

@interface PAMUsersTableViewController ()

@property(strong, nonatomic) NSArray *arrayWithUsers;

@end

@implementation PAMUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayWithUsers = [NSArray new];
    NSManagedObjectContext *contex = [[PAMDataStore standartDataStore] mainContext];
    self.arrayWithUsers = [PAMUserCore fetchAllUsersInContext:contex];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWithUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                        reuseIdentifier:@"UserCell"];
    }
    
    PAMUserCore *userCore = (PAMUserCore*)[self.arrayWithUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = userCore.name;
    NSManagedObjectContext *contex = [[PAMDataStore standartDataStore] mainContext];
    NSArray *array = [PAMPartyCore fetchPartiesWithLocationByUserId:userCore.userId context:contex];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld parties", [array count]];
    return cell;
}


#pragma mark - UITableViewDataSource

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapUserPartiesSegue"]) {
        NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        PAMUserCore *userCore = (PAMUserCore*)[self.arrayWithUsers objectAtIndex:selectedRow];
        PAMMapViewController *mapViewController = [segue destinationViewController];
        mapViewController.typeMap = PAMMapStateRead;
        NSMutableArray * arrayParties = [NSMutableArray new];
        for(PAMPartyCore *partyCore in [userCore parties] ){
            [arrayParties addObject:partyCore];
        }
        mapViewController.arrayWithParties = (NSArray *)arrayParties;
        [mapViewController.navigationItem setTitle:[userCore.name uppercaseString]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
