//
//  PAMDataStore.m
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMDataStore.h"

@interface PAMDataStore()

@property (readwrite, strong, nonatomic) NSManagedObjectContext *mainContext;
@property (readwrite, strong, nonatomic) NSManagedObjectContext *backgroundContext;

@property (readwrite, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readwrite, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation PAMDataStore

+ (PAMDataStore *) standartDataStore {
    static PAMDataStore *dataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataStore = [[PAMDataStore alloc] init];
    });
    return dataStore;
}



- (void)addPartiesFromServerToCoreData:(NSArray *) serverParty byCreatorPartyId:(NSInteger)creatorId completion:(void(^)())completion{
    __weak PAMDataStore *weakSelf = self;
    [self.backgroundContext performBlock:^{
        for (id serverPary in serverParty) {
            PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:weakSelf.backgroundContext];
            partyCore.partyId = [[serverPary objectForKey:@"id"] longLongValue];
            partyCore.name = [serverPary objectForKey:@"name"];
            partyCore.partyDescription = [serverPary objectForKey:@"comment"];
            partyCore.partyType = [[serverPary objectForKey:@"logo_id"] longLongValue];
            partyCore.startDate = [[serverPary objectForKey:@"start_time"] longLongValue];
            partyCore.endDate = [[serverPary objectForKey:@"end_time"] longLongValue];
            partyCore.isLoaded = YES;
            partyCore.longitude = [serverPary objectForKey:@"longitude"];
            partyCore.latitude = [NSString removeEscapeSpecialCharactersWithString:[serverPary objectForKey:@"latitude"]];
            PAMUserCore *userCore = (PAMUserCore *)[PAMUserCore fetchUserByUserId:creatorId context:weakSelf.backgroundContext];
            partyCore.creatorParty = userCore;
        }
        if (weakSelf.backgroundContext.hasChanges) {
            NSError *error = nil;
            [weakSelf.backgroundContext save:&error];
            if(error) {
                NSLog(@"%s, error happened - %@", __PRETTY_FUNCTION__, error);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

- (void)addUsersFromServerToCoreData:(NSArray *) serverUsers completion:(void(^)())completion{
     __weak PAMDataStore *weakSelf = self;
    [self.backgroundContext performBlock:^{
        for (id serverUser in serverUsers) {
            PAMUserCore *userCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMUserCore" inManagedObjectContext:self.backgroundContext];
            userCore.userId = [[serverUser objectForKey:@"id"] longLongValue];
            userCore.name = [serverUser objectForKey:@"name"];
            userCore.isLoaded = YES;
        }
        if (weakSelf.backgroundContext.hasChanges) {
            NSError *error = nil;
            [weakSelf.backgroundContext save:&error];
            if(error) {
                NSLog(@"%s, error happened - %@", __PRETTY_FUNCTION__, error);
            }
        }
        
        if (completion) {
            completion();
        }
        
    }];
}

- (void)addAllUsersWithPartiesFromServer {
    [[PAMPartyMakerAPI standartPartyMakerAPI] allUsersWithCallback:^(NSDictionary *response, NSError *error) {
        if([[response objectForKey:@"statusCode"] isEqual:@200]){
            NSArray *array = [response objectForKey:@"response"];
            if(![array isEqual:[NSNull null]]) {
                [self clearCoreData];
                [[PAMDataStore standartDataStore] addUsersFromServerToCoreData: array completion:^{
                    [self addAllPartiesFromServer];
                }];
                
            }
        } 
    }];
}

- (void)addAllPartiesFromServer {
    for (PAMUserCore *userCore in [PAMUserCore fetchAllUsersInContext:self.backgroundContext]) {
        [[PAMPartyMakerAPI standartPartyMakerAPI] partiesWithCreatorId:@(userCore.userId) callback:^(NSDictionary *response, NSError *error) {
            if([[response objectForKey:@"statusCode"] isEqual:@200]){
                NSArray *array = [response objectForKey:@"response"];
                if(![array isEqual:[NSNull null]]) {
                    [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
                        for (id serverPary in array) {
                            PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:backgroundContext];
                            partyCore.partyId = [[serverPary objectForKey:@"id"] longLongValue];
                            partyCore.name = [serverPary objectForKey:@"name"];
                            partyCore.partyDescription = [serverPary objectForKey:@"comment"];
                            partyCore.partyType = [[serverPary objectForKey:@"logo_id"] longLongValue];
                            partyCore.startDate = [[serverPary objectForKey:@"start_time"] longLongValue];
                            partyCore.endDate = [[serverPary objectForKey:@"end_time"] longLongValue];
                            partyCore.longitude = [serverPary objectForKey:@"longitude"];
                            partyCore.latitude = [NSString removeEscapeSpecialCharactersWithString:[serverPary objectForKey:@"latitude"]];
                            partyCore.isLoaded = YES;
                            partyCore.creatorParty = userCore;
                            //[PAMLocalNotification notificationForRarty:partyCore];
                        }
                    } completion:^{
                        
                    }];
                } else {
                    
                }
            } else {
                NSLog(@"server answer %@",[response objectForKey:@"statusCode"]);
            }
        }];
    }
   
}

- (void)upDateTable {
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    PAMPartyMakerAPI *partyMakerAPI = [PAMPartyMakerAPI standartPartyMakerAPI];
    [partyMakerAPI partiesWithCreatorId:@(userId) callback:^(NSDictionary *response, NSError *error) {
        if([response objectForKey:@"response"]) {
            NSArray *array = [response objectForKey:@"response"];
            if(![array isEqual:[NSNull null]]){
                [[PAMDataStore standartDataStore] clearPartiesByUserId:userId];
                [[PAMDataStore standartDataStore] addPartiesFromServerToCoreData:array byCreatorPartyId:userId completion:nil];
            }
        }
    }];
}

- (void)upDateOfflinePartiesByUserId:(NSInteger) userId {
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    NSArray * parties = [PAMPartyCore fetchPartiesByUserId:userId context:context];
    for (PAMPartyCore *party in parties) {
        if(!party.isLoaded) {
            [[PAMPartyMakerAPI standartPartyMakerAPI] addParty:party creatorId:@(userId) callback:^(NSDictionary *response, NSError *error) { }];
        }
    }
}

#pragma mark - Helpers
- (void)dropAllUsersWithPartiesOnServer {
    NSManagedObjectContext *mainContext = [[PAMDataStore standartDataStore] mainContext];
    for (PAMUserCore *userCore in [PAMUserCore fetchAllUsersInContext:mainContext]) {
        NSArray *arrayWithParties = [PAMPartyCore fetchPartiesByUserId:(NSInteger)userCore.userId context:mainContext];
        for (PAMPartyCore *partyCore in arrayWithParties) {
            [[PAMPartyMakerAPI standartPartyMakerAPI] deletePartyById:@(partyCore.partyId) creator_id:@(userCore.userId) callback:^(NSDictionary *response, NSError *error) {
                NSLog(@"Party %@", response);
            }];
        }
        [[PAMPartyMakerAPI standartPartyMakerAPI] deleteUserById:@(userCore.userId) callback:^(NSDictionary *response, NSError *error) {
            NSLog(@"User %@", response);
        }];
    }
}

- (void)clearPartiesByUserId:(NSInteger) userId {
    [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
        NSArray * parties = [PAMPartyCore fetchPartiesByUserId:userId context:backgroundContext];
        for (PAMPartyCore *party in parties) {
            [backgroundContext deleteObject:party];
        }
    } completion:^{
        
    }];
}

- (void)clearCoreData{
    [PAMLocalNotification removeAllNotifications];
    
    [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
        NSArray * parties = [PAMPartyCore fetchAllPartiesInContext:backgroundContext];
        NSLog(@"Will delete (%ld) paries", (unsigned long)[parties count]);
        for (PAMPartyCore *party in parties) {
            [backgroundContext deleteObject:party];
        }
        
        NSArray * users = [PAMUserCore fetchAllUsersInContext:backgroundContext];
        NSLog(@"Will delete (%ld) users", (unsigned long)[users count]);
        for (PAMUserCore *user in users) {
            [backgroundContext deleteObject:user];
        }
        
    } completion:^{
        NSLog(@"Deleted all users from core date");
    }];
}

#pragma mark - Core Data stack
- (void)performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion {
    __weak PAMDataStore *weakSelf = self;
    [self.backgroundContext performBlock:^{
        writeBlock(weakSelf.backgroundContext);
        if (weakSelf.backgroundContext.hasChanges) {
            NSError *error = nil;
            [weakSelf.backgroundContext save:&error];
            if(error) {
                NSLog(@"%s, error happened - %@", __PRETTY_FUNCTION__, error);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PAMCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    if (_persistentStoreCoordinator ) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PAMCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainContext {
    
    if ( _mainContext ) {
        return _mainContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainContext.persistentStoreCoordinator = coordinator;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyMainContextContextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:_mainContext];
    return _mainContext;
}

- (NSManagedObjectContext *)backgroundContext {
    if (_backgroundContext ) {
        return _backgroundContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_backgroundContext setPersistentStoreCoordinator:coordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyBackgroundContextContextChanges:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:_backgroundContext];
    return _backgroundContext;
}

- (void)applyBackgroundContextContextChanges:(NSNotification *) notification {
    @synchronized (self) {
        [self.mainContext performBlock:^{
            [self.mainContext mergeChangesFromContextDidSaveNotification: notification];
        }];
    }
}

- (void)applyMainContextContextChanges:(NSNotification *) notification {
    @synchronized (self) {
        [self.backgroundContext performBlock:^{
            [self.backgroundContext mergeChangesFromContextDidSaveNotification: notification];
        }];
    }
}


@end
