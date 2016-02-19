//
//  PAMDataStore.h
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PAMPartyCore.h"
#import "PAMUserCore.h"


@interface PAMDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;

+ (PAMDataStore *) standartDataStore;

- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion;

#pragma mark - Fetches Party
- (void) deleteAllParties;
- (NSArray *)fetchPartyByPartyId:(NSInteger) partyId context:(NSManagedObjectContext*) context;
- (NSArray *)fetchPartiesByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context;
- (NSArray *)fetchAllParties;

#pragma mark - Fetches User
- (NSArray *) fetchUserByUserId:(NSInteger)userId context:(NSManagedObjectContext*) context;
- (NSArray *)fetchAllUsers;

- (void) writeUserToCoreDataInBackroundThread:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion;


@end
