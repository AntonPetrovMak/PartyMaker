//
//  PAMPartyTableCell.m
//  PartyMaker
//
//  Created by Petrov Anton on 11.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartyTableCell.h"

@implementation PAMPartyTableCell

+ (NSString *) reuseIdentifire {
    return @"PAMPartyTableCell";
}

- (void) configureWithPartyName:(NSString *) partyName partyDate:(NSString *) partyDate partyType:(UIImage *) partyType partyAddress:(NSString *) address{
    self.partyNameLabel.text = [partyName uppercaseString];
    self.partyDateLabel.text = [partyDate uppercaseString];
    self.patryTypeImage.image = partyType;
    self.partyAddressLabel.text = [address uppercaseString];
}

@end
