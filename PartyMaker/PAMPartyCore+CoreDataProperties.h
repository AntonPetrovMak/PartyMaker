//
//  PAMPartyCore+CoreDataProperties.h
//  PartyMaker
//
//  Created by iMac309 on 24.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PAMPartyCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAMPartyCore (CoreDataProperties)

@property (nonatomic) int64_t endDate;
@property (nonatomic) BOOL isLoaded;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *partyDescription;
@property (nonatomic) int64_t partyId;
@property (nonatomic) int64_t partyType;
@property (nonatomic) int64_t startDate;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitude;
@property (nonatomic) BOOL isWasDeleted;
@property (nullable, nonatomic, retain) PAMUserCore *creatorParty;

@end

NS_ASSUME_NONNULL_END
