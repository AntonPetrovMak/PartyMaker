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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld parties", [userCore.parties count]];
    return cell;
}


#pragma mark - UITableViewDataSource

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapUserPartiesSegue"]) {
        PAMUsersPartiesViewController *mapViewController = [segue destinationViewController];
        mapViewController.arrayWithParties = (NSArray*)[[self.arrayWithUsers objectAtIndex:5] parties];
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    PAMUsersPartiesViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PAMUsersPartiesViewController"];
//
//    mapViewController.arrayWithParties = (NSArray*)[[self.arrayWithUsers objectAtIndex:indexPath.row] parties];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
