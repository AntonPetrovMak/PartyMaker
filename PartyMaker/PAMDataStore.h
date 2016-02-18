//
//  PAMDataStore.h
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PAMParty.h"
@class PAMNewViewController;

@interface PAMDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (PAMDataStore *) standartDataStore;

- (void) writePartiesToPlist:(NSMutableArray *) arrayParties;
- (void) writePartyToPlist:(PAMParty *) party;
- (NSMutableArray *) arrayWithParties;

@end
