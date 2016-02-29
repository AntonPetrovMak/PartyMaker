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

- (void)addUserFromServer:(id) serverUser {
    [self performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
        PAMUserCore *userCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMUserCore" inManagedObjectContext:backgroundContext];
        userCore.userId = [[serverUser objectForKey:@"id"] longLongValue];
        userCore.name = [serverUser objectForKey:@"name"];
        userCore.isLoaded = YES;
        NSLog(@"It has been added user: %@", [serverUser objectForKey:@"name"]);
    } completion:nil];
}

- (void)addPartyFromServerByCreatorId:(NSInteger) creatorId serverParty:(id) serverParty {
    [self performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
        PAMUserCore *userCore = (PAMUserCore*)[PAMUserCore fetchUserByUserId:creatorId context:backgroundContext];
        PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:backgroundContext];
        partyCore.partyId = [[serverParty objectForKey:@"id"] longLongValue];
        partyCore.name = [serverParty objectForKey:@"name"];
        partyCore.partyDescription = [serverParty objectForKey:@"comment"];
        partyCore.partyType = [[serverParty objectForKey:@"logo_id"] longLongValue];
        partyCore.startDate = [[serverParty objectForKey:@"start_time"] longLongValue];
        partyCore.endDate = [[serverParty objectForKey:@"end_time"] longLongValue];
        partyCore.longitude = [serverParty objectForKey:@"longitude"];
        partyCore.latitude = [NSString removeEscapeSpecialCharactersWithString:[serverParty objectForKey:@"latitude"]];
        partyCore.isLoaded = YES;
        partyCore.creatorParty = userCore;
        NSLog(@"It has been added to the party: %@ by creator: %@",[serverParty objectForKey:@"name"], userCore.name);
    } completion:nil];
}

- (void)upDateUsersWithPartiesFromServer {
    NSManagedObjectContext *weakMainContext = self.mainContext;
    [[PAMPartyMakerAPI standartPartyMakerAPI] allUsersWithCallback:^(NSDictionary *response, NSError *error) {
        if([[response objectForKey:@"statusCode"] isEqual:@200]){
            NSArray *array = [response objectForKey:@"response"];
            if(![array isEqual:Nil]){
                for (id serverUser in array) {
                    NSInteger serverUserId = [[serverUser objectForKey:@"id"] integerValue];
                    PAMUserCore *userCore = (PAMUserCore*)[PAMUserCore fetchUserByUserId:serverUserId context:weakMainContext];
                    if(!userCore) {
                        NSLog(@"No user %@", [serverUser objectForKey:@"name"]);
                        [self addUserFromServer:serverUser];
                    }
                    [self upDatePartyByUserId:(NSInteger)userCore.userId];
                }
            }
        } else {
            NSLog(@"No code 200 (load users)");
        }
    }];
}

- (void)upDatePartyByUserId:(NSInteger) userId {
    [[PAMPartyMakerAPI standartPartyMakerAPI] partiesWithCreatorId:@(userId) callback:^(NSDictionary *response, NSError *error) {
        if([[response objectForKey:@"statusCode"] isEqual:@200]){
            NSArray *array = [response objectForKey:@"response"];
            if(![array isEqual:[NSNull null]]){
                [self clearPartiesByUserId:userId];
                for (id serverParty in array) {
                     [self addPartyFromServerByCreatorId:userId serverParty:serverParty];
                }
            }
        } else {
            NSLog(@"No code 200 (load parties)");
        }
    }];
}

- (void)upDateOfflinePartiesByUserId:(NSInteger) userId {
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    NSArray * parties = [PAMPartyCore fetchPartiesIsNotDownloadedInContext:context];
    if(!parties) {
        for (PAMPartyCore *party in parties) {
            [[PAMPartyMakerAPI standartPartyMakerAPI] addParty:party creatorId:@(userId) callback:^(NSDictionary *response, NSError *error) { }];
        }
        [self clearPartiesByUserId:userId];
        [self upDatePartyByUserId:userId];
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
