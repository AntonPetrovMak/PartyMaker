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

- (void)configureWithParty:(PAMPartyCore *) party {
    self.partyNameLabel.text = [party.name uppercaseString];
    self.partyDescriptionLabel.text = [NSString stringWithFormat:@" \"%@\" ", party.partyDescription.length ? party.partyDescription : @"not description" ];
    self.partyTypeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)party.partyType]];
    self.partyDateLabel.text = [NSString stringPrityDateWithDate:[NSDate dateWithTimeIntervalSince1970:party.startDate]];
    self.partyTimeStartLabel.text = [NSString stringHourAndMinutesWithInterval:party.startDate];
    self.partyTimeEndLabel.text = [NSString stringHourAndMinutesWithInterval:party.endDate];
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
        //PAMNewViewController *editView = [segue destinationViewController];
        //editView.partyCore = self.party;
    }
}



#pragma mark - Action

- (IBAction)actionEditParty:(UIButton *)sender {
    
}

- (IBAction)actionDeleteParty:(UIButton *)sender {
    // go to root controller
    [PAMPartyCore deletePartyWithCompletion:nil byPartyId: self.party.partyId];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
