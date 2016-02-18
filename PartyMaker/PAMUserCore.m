//
//  PAMUserCore.m
//  PartyMaker
//
//  Created by Petrov Anton on 18.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMUserCore.h"
#import "PAMPartyCore.h"

@implementation PAMUserCore

/*#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:@(self.userId) forKey:@"userId"];
    [aCoder encodeBool:self.isLoaded forKey:@"isLoaded"];
    [aCoder encodeObject:self.parties forKey:@"parties"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(!self) return nil;
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.userId = [[aDecoder decodeObjectForKey:@"userId"] intValue];
    self.isLoaded = [aDecoder decodeBoolForKey:@"isLoaded"];
    self.parties = [aDecoder decodeObjectForKey:@"parties"];
    return self;
}*/


@end
