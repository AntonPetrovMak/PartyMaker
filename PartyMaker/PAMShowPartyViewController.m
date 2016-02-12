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
//    NSAttributedString *string = [[NSAttributedString alloc] initWithString:self attributes:attr];
//    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
//    
//    CGSizeMake(roundf(rect.size.width), roundf(rect.size.height));
//    
//    NSMutableParagraphStyle *ps = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    ps.lineBreakMode = NSLineBreakByWordWrapping;
//    : @{NSFontAttributeName:[UIFont fontWithName:FontName size:FontSize], NSParagraphStyleAttributeName:ps}
    
    NSAssert1(self.party, @"self.party in nil", nil);
    [self configureWithParty:self.party];
}

- (void) configureWithParty:(PAMParty *) party {
    self.partyNameLabel.text = party.partyName;
    self.partyDescriptionTextView.text = party.partyDescription;
    self.partyTypeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)party.partyType]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    self.partyDateLabel.text = [dateFormatter stringFromDate:party.partyStartDate];
    [dateFormatter setDateFormat: @"HH:mm"];
    self.partyTimeStartLabel.text = [dateFormatter stringFromDate:party.partyStartDate];
    self.partyTimeEndLabel.text = [dateFormatter stringFromDate:party.partyEndDate];
}

@end
