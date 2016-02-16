//
//  PAMUser.m
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMUser.h"

@implementation PAMUser

-(instancetype) initWithName:(NSString *) name email:(NSString *) email userId:(int) userId {
    self = [super init];
    if(!self) return nil;
    self.name = name;
    self.email = email;
    self.userId = userId;
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:@(self.userId) forKey:@"userId"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(!self) return nil;
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.userId = [[aDecoder decodeObjectForKey:@"userId"] intValue];
    return self;
}

@end
