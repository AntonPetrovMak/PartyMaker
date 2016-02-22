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
#import "PAMPartyMakerAPI.h"


@interface PAMDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;

+ (PAMDataStore *) standartDataStore;
- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion;

#pragma mark - Fetches Party
- (void)addPartiesFromServerToCoreData:(NSArray *) serverParty byCreatorPartyId:(NSInteger)creatorId completion:(void(^)())completion;
- (NSArray *)fetchPartyByPartyId:(NSInteger) partyId context:(NSManagedObjectContext*) context;
- (NSArray *)fetchPartiesByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context;
- (NSArray *)fetchAllPartiesInContext:(NSManagedObjectContext*) context;
- (void)upDateOfflinePartiesByUserId:(NSInteger) userId;

#pragma mark - Fetches User
- (void)addUsersFromServerToCoreData:(NSArray *) serverUsers completion:(void(^)())completion;
- (void)clearPartiesByUserId:(NSInteger) userId;
- (NSArray *)fetchUserByUserId:(NSInteger)userId context:(NSManagedObjectContext*) context;
- (NSArray *)fetchAllUsersInContext:(NSManagedObjectContext*) context;

- (void)addAllUsersWithPartiesFromServer;
- (void)dropAllUsersWithPartiesOnServer;
- (void)clearCoreData;



@end
