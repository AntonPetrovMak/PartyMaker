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
    
    NSAssert1(self.party, @"self.party in nil", nil);
    [self configureWithParty:self.party];
}

- (void) configureWithParty:(PAMParty *) party {
    self.partyNameLabel.text = party.partyName;
    self.partyDescriptionTextView.text = party.partyDescription;
    self.partyTypeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", party.partyType]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    self.partyDateLabel.text = [dateFormatter stringFromDate:party.partyStartDate];
    [dateFormatter setDateFormat: @"HH:mm"];
    self.partyTimeStartLabel.text = [dateFormatter stringFromDate:party.partyStartDate];
    self.partyTimeEndLabel.text = [dateFormatter stringFromDate:party.partyEndDate];
//    NSCalendar *calendar =[NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear |
//                                                            NSCalendarUnitMonth | NSCalendarUnitDay
//                                               fromDate:party.partyStartDate];
//    self.partyTimeStartLabel.text = [NSString stringWithFormat:@"%ld:%ld",[components hour], [components minute]];
//    self.partyDateLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld",[components month], [components day], [components year]];
}

@end
