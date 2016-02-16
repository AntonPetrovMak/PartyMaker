//
//  PAMParty.h
//  PartyMaker
//
//  Created by iMac309 on 07.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAMParty : NSObject <NSCoding>

@property(assign, nonatomic) NSInteger partyId;
@property(strong, nonatomic) NSString *partyName;
@property(strong, nonatomic) NSDate *partyStartDate;
@property(strong, nonatomic) NSDate *partyEndDate;
@property(assign, nonatomic) NSInteger partyType;
@property(strong, nonatomic) NSString *partyDescription;

-(instancetype) initWithPartyId:(NSInteger) partyId name:(NSString *) name startDate:(NSDate *) startDate endDate:(NSDate *) endDate paryType:(NSInteger) partyType description:(NSString *)description;


@end
