//
//  PAMPartyCore+CoreDataProperties.h
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PAMPartyCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAMPartyCore (CoreDataProperties)

@property (nonatomic) int64_t partyId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) int64_t endDate;
@property (nullable, nonatomic, retain) NSString *partyDescription;
@property (nonatomic) int64_t partyType;
@property (nullable, nonatomic, retain) PAMUserCore *partyRelationship;

@end

NS_ASSUME_NONNULL_END
