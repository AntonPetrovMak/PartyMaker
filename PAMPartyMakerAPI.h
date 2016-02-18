//
//  PAMPartyMakerAPI.h
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PAMUserCore.h"
@interface PAMPartyMakerAPI : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (PAMPartyMakerAPI *) standartPartyMakerAPI;

- (void)loginWithUserName:(NSString *) _username andPassword:(NSString *) _pass callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)registerWithUserName:(NSString *) _username andPassword:(NSString *) _pass andEmail:(NSString *) _email callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)partiesWithCreatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block;
//- (void)writeParty:(PAMParty *) party withCreatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)deletePartyById:(NSNumber *) partyId callback:(void(^)(NSDictionary *response, NSError *error)) block;

- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion;

@end
