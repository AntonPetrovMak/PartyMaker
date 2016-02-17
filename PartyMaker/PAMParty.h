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
@property(assign, nonatomic) NSInteger partyStartDate;
@property(assign, nonatomic) NSInteger partyEndDate;
@property(assign, nonatomic) NSInteger partyType;
@property(strong, nonatomic) NSString *partyDescription;

-(instancetype) initWithPartyId:(NSInteger) partyId name:(NSString *) name startDate:(NSInteger) startDate endDate:(NSInteger) endDate paryType:(NSInteger) partyType description:(NSString *)description;


@end
