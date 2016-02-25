//
//  PAMUserCore.h
//  PartyMaker
//
//  Created by iMac309 on 21.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PAMPartyCore;

NS_ASSUME_NONNULL_BEGIN

@interface PAMUserCore : NSManagedObject

+ (NSArray *)fetchUserByUserId:(NSInteger)userId context:(NSManagedObjectContext*) context;
+ (NSArray *)fetchAllUsersInContext:(NSManagedObjectContext*) context;

@end

NS_ASSUME_NONNULL_END

#import "PAMUserCore+CoreDataProperties.h"
