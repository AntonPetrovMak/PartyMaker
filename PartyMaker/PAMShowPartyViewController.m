//
//  PAMShowPartyViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 11.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMShowPartyViewController.h"

@interface PAMShowPartyViewController ()

@end

@implementation PAMShowPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self emptyParty];
    if(self.party) {
        [self configureWithParty:self.party];
    }
}

- (void)configureWithParty:(PAMParty *) party {
    self.partyNameLabel.text = [party.partyName uppercaseString];
    self.partyDescriptionLabel.text = [NSString stringWithFormat:@" \"%@\" ", party.partyDescription.length ? party.partyDescription : @"not description" ];
    self.partyTypeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)party.partyType]];
    self.partyDateLabel.text = [NSString stringPrityDateWithDate:party.partyStartDate];
    self.partyTimeStartLabel.text = [NSString stringHourAndMinutesWithDate: party.partyStartDate];
    self.partyTimeEndLabel.text = [NSString stringHourAndMinutesWithDate:party.partyEndDate];
}

- (void)emptyParty{
    self.partyNameLabel.text = [@"not name" uppercaseString];
    self.partyDescriptionLabel.text = @"not description";
    self.partyTypeImageView.image = nil;
    self.partyDateLabel.text = @"00.00.0000";
    self.partyTimeStartLabel.text = @"00:00";
    self.partyTimeEndLabel.text = @"00:00";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueEditParty"]) {
        PAMNewViewController *editView = [segue destinationViewController];
        PAMParty *party = [[PAMDataStore standartDataStore] arrayWithParties][self.indexCurrentCell];
        editView.party = party;
        editView.indexCurrentCell = self.indexCurrentCell;
    }
}



#pragma mark - Action

- (IBAction)actionEditParty:(UIButton *)sender {
    
}

- (IBAction)actionDeleteParty:(UIButton *)sender {
    NSMutableArray* paties = [[PAMDataStore standartDataStore] arrayWithParties];
    [paties removeObjectAtIndex:self.indexCurrentCell];
    [[PAMDataStore standartDataStore] writePartiesToPlist:paties];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
