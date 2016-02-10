//
//  PAMParty.m
//  PartyMaker
//
//  Created by iMac309 on 07.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMParty.h"

@implementation PAMParty

-(instancetype) initWithName:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate paryType:(NSInteger) partyType description:(NSString *)description {
    self = [super init];
    if(!self) return nil;
    self.partyName = name;
    self.partyStartDate = startDate;
    self.partyEndDate = endDate;
    self.partyType = partyType;
    self.partyDescription = description;
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nName: %@ \nStart: %@ \nEnd: %@ \nType: %d \nDescription: %@", self.partyName , self.partyStartDate, self.partyEndDate, (int)self.partyType, self.partyDescription];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.partyName forKey:@"partyName"];
    [aCoder encodeObject:self.partyStartDate forKey:@"partyStartDate"];
    [aCoder encodeObject:self.partyEndDate forKey:@"partyEndDate"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.partyType] forKey:@"partyType"];
    [aCoder encodeObject:self.partyDescription forKey:@"partyDescription"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(!self) return nil;
    self.partyName = [aDecoder decodeObjectForKey:@"partyName"];
    self.partyStartDate = [aDecoder decodeObjectForKey:@"partyStartDate"];
    self.partyEndDate = [aDecoder decodeObjectForKey:@"partyEndDate"];
    self.partyType = [[aDecoder decodeObjectForKey:@"partyType"] integerValue];
    self.partyDescription = [aDecoder decodeObjectForKey:@"partyDescription"];
    return self;
}

@end
