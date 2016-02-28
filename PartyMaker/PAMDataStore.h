//
//  PAMDataStore.h
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "NSString+PAMDateFormat.h"
#import "PAMLocalNotification.h"
#import "PAMPartyMakerAPI.h"
#import "PAMPartyCore.h"
#import "PAMUserCore.h"



@interface PAMDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;

+ (PAMDataStore *) standartDataStore;
- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion;

- (void)addPartiesFromServerToCoreData:(NSArray *) serverParty byCreatorPartyId:(NSInteger)creatorId completion:(void(^)())completion;
- (void)upDateOfflinePartiesByUserId:(NSInteger) userId;

- (void)addUsersFromServerToCoreData:(NSArray *) serverUsers completion:(void(^)())completion;
- (void)clearPartiesByUserId:(NSInteger) userId;

- (void)addAllUsersWithPartiesFromServer;
- (void)dropAllUsersWithPartiesOnServer;
- (void)clearCoreData;



@end
