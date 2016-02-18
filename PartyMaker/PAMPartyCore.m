//
//  PAMPartyCore.m
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartyCore.h"
#import "PAMUserCore.h"

@implementation PAMPartyCore

- (NSString *)description {
    return [NSString stringWithFormat:@"\nId: %d\nName: %@ \nStart: %@ \nEnd: %@ \nType: %d \nDescription: %@\n\n",
            (int)self.partyId, self.name , [NSDate dateWithTimeIntervalSince1970:self.startDate], [NSDate dateWithTimeIntervalSince1970:self.endDate], (int)self.partyType, self.partyDescription];
}

@end
