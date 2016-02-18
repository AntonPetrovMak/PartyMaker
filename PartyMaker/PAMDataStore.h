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


@interface PAMDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (PAMDataStore *) standartDataStore;

- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion;
- (void) deletePartyByPartyId:(NSInteger) partyId withCompletion:(void (^)(void))completion;

#pragma mark - Fetches Party
- (NSArray *)fetchPartyByPartyId:(NSInteger) partyId;
- (NSArray *)fetchPartiesByUserId:(NSInteger) userId;
- (NSArray *)fetchAllParties;
- (void)fetchAllParties:(void (^)(NSArray*)) allPartiesBlock completion:(void(^)())completion;

#pragma mark - Fetches User
- (NSArray *)fetchUserWithName:(NSString *) name email:(NSString *)email userId:(NSInteger) userId;
- (NSArray *)fetchAllUsers;


@end
