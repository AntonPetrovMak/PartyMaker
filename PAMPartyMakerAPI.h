//
//  PAMPartyMakerAPI.h
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAMDataStore.h"
#import "PAMUserCore.h"

@interface PAMPartyMakerAPI : NSObject


+ (PAMPartyMakerAPI *) standartPartyMakerAPI;

- (void)loginWithUserName:(NSString *) _username andPassword:(NSString *) _pass callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)registerWithUserName:(NSString *) _username andPassword:(NSString *) _pass andEmail:(NSString *) _email callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)partiesWithCreatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)addParty:(PAMPartyCore *) party creatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)deletePartyById:(NSNumber *) partyId creator_id:(NSNumber *) creator_id callback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)allUsersWithCallback:(void(^)(NSDictionary *response, NSError *error)) block;
- (void)deleteUserById:(NSNumber *) creator_id callback:(void(^)(NSDictionary *response, NSError *error)) block;

@end
