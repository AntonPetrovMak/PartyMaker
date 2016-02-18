//
//  PAMUserCore.h
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAMUserCore : NSManagedObject

+ (NSArray *)fetchUsersWithContext:(NSManagedObjectContext *) context;
+ (PAMUserCore *)fetchUserWithContext:(NSManagedObjectContext *) context byUserId:(NSInteger) userId;

@end

NS_ASSUME_NONNULL_END

#import "PAMUserCore+CoreDataProperties.h"
