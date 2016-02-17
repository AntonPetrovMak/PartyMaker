//
//  PAMParty.m
//  PartyMaker
//
//  Created by iMac309 on 07.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMParty.h"

@implementation PAMParty

-(instancetype) initWithPartyId:(NSInteger) partyId name:(NSString *) name startDate:(NSInteger) startDate endDate:(NSInteger) endDate paryType:(NSInteger) partyType description:(NSString *)description {
    self = [super init];
    if(!self) return nil;
    self.partyId = partyId;
    self.partyName = name;
    self.partyStartDate = startDate;
    self.partyEndDate = endDate;
    self.partyType = partyType;
    self.partyDescription = description;
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nId: %d\nName: %@ \nStart: %@ \nEnd: %@ \nType: %d \nDescription: %@",
            (int)self.partyId, self.partyName , [NSDate dateWithTimeIntervalSince1970:self.partyStartDate], [NSDate dateWithTimeIntervalSince1970:self.partyEndDate], (int)self.partyType, self.partyDescription];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.partyId] forKey:@"partyId"];
    [aCoder encodeObject:self.partyName forKey:@"partyName"];
    [aCoder encodeObject:[NSNumber numberWithInteger: self.partyStartDate] forKey:@"partyStartDate"];
    [aCoder encodeObject:[NSNumber numberWithInteger: self.partyEndDate] forKey:@"partyEndDate"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.partyType] forKey:@"partyType"];
    [aCoder encodeObject:self.partyDescription forKey:@"partyDescription"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(!self) return nil;
    self.partyId = [[aDecoder decodeObjectForKey:@"partyId"] integerValue];
    self.partyName = [aDecoder decodeObjectForKey:@"partyName"];
    self.partyStartDate = [[aDecoder decodeObjectForKey:@"partyStartDate"] integerValue];
    self.partyEndDate = [[aDecoder decodeObjectForKey:@"partyEndDate"] integerValue];
    self.partyType = [[aDecoder decodeObjectForKey:@"partyType"] integerValue];
    self.partyDescription = [aDecoder decodeObjectForKey:@"partyDescription"];
    return self;
}

@end
