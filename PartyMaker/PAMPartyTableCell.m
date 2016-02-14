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

- (void) configureWithPartyName:(NSString *) partyName partyDate:(NSString *) partyDate partyType:(UIImage *) partyType {
    self.partyNameLabel.text = [partyName uppercaseString];
    self.partyDateLabel.text = partyDate;
    self.patryTypeImage.image = partyType;
}

@end
