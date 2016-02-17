//
//  PAMPartyCore.h
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PAMDataStore.h"
#import "PAMParty.h"

@class PAMUserCore;

NS_ASSUME_NONNULL_BEGIN

@interface PAMPartyCore : NSManagedObject

+ (PAMPartyCore *) fetchPartyWithContext:(NSManagedObjectContext *) context byPartyId:(NSInteger) partyId;
+ (NSArray *) fetchPartiesWithContext:(NSManagedObjectContext *) context byUserId:(NSInteger) userId;
+ (NSArray *) fetchPartiesWithContext:(NSManagedObjectContext *) context;

+ (void) deletePartyWithCompletion:(void (^ _Nullable )(void))completion byPartyId:(NSInteger) partyId;

+ (void) createParty:(PAMParty *) party withContext:(NSManagedObjectContext *) contex;

@end

NS_ASSUME_NONNULL_END

#import "PAMPartyCore+CoreDataProperties.h"
