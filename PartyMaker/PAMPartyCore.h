//
//  PAMPartyCore.h
//  PartyMaker
//
//  Created by iMac309 on 21.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PAMUserCore;

NS_ASSUME_NONNULL_BEGIN

@interface PAMPartyCore : NSManagedObject

+ (NSArray *)fetchPartiesIsNotDownloadedInContext:(NSManagedObjectContext*) context;
+ (NSArray *)fetchPartyByPartyId:(NSInteger) partyId context:(NSManagedObjectContext*) context;
+ (NSArray *)fetchPartiesByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context;
+ (NSArray *)fetchPartiesWithLocationByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context;

+ (NSArray *)fetchAllPartiesInContext:(NSManagedObjectContext*) context;

@end

NS_ASSUME_NONNULL_END

#import "PAMPartyCore+CoreDataProperties.h"
