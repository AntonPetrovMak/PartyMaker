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

#pragma mark - Fetches Party
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
            PAMUserCore *userCore = (PAMUserCore *)[[PAMDataStore standartDataStore] fetchUserByUserId:creatorId context:weakSelf.backgroundContext];
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

- (NSArray *)fetchPartyByPartyId:(NSInteger) partyId context:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partyId == %ld", partyId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return [fetchedObjects lastObject];
}

- (NSArray *)fetchPartiesByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creatorParty.userId == %ld", userId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return fetchedObjects;
}

- (NSArray *)fetchAllPartiesInContext:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creatorParty.userId"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];

    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    /*for (PAMPartyCore *party in fetchedObjects) {
        NSLog(@"Creator party: %@ Name party: %@", party.creatorParty.name, party.name);
    }*/
    return fetchedObjects;
}

#pragma mark - Fetches User

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

- (NSArray *)fetchUserByUserId:(NSInteger)userId context:(NSManagedObjectContext*)context {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %lld", (long long)userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return [fetchedObjects lastObject];
}

- (NSArray *)fetchAllUsersInContext:(NSManagedObjectContext*) context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    //    for (PAMUserCore *userCore in fetchedObjects) {
    //        NSLog(@"User core name: %@",userCore.name);
    //    }
    return fetchedObjects;
}

#pragma mark - Synchronization with server

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

- (void) notificationForRarty:(PAMPartyCore *) party {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Party time!";
    localNotification.alertAction = @"Pool party is about to begin!";
    localNotification.fireDate = [NSDate dateWithTimeIntervalSince1970:party.startDate];
    localNotification.userInfo = @{ @"party_id" : @(party.partyId) };
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.repeatInterval = 0;
    localNotification.category = @"LocalNotificationDefaultCategory";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    UIMutableUserNotificationAction *doneAction = [[UIMutableUserNotificationAction alloc] init];
    doneAction.identifier = @"doneActionIdentifier";
    doneAction.destructive = NO;
    doneAction.title = @"Mark done";
    doneAction.activationMode = UIUserNotificationActivationModeBackground;
    doneAction.authenticationRequired = NO;
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"LocalNotificationDefaultCategory";
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextMinimal];
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextDefault];
    NSSet *categories = [[NSSet alloc] initWithArray:@[category]];
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings
                                                        settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}


- (void)addAllPartiesFromServer {
    for (PAMUserCore *userCore in [[PAMDataStore standartDataStore] fetchAllUsersInContext:self.backgroundContext]) {
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
                            partyCore.isLoaded = YES;
                            partyCore.creatorParty = userCore;
                            [self notificationForRarty: partyCore];
                            
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

- (void)dropAllUsersWithPartiesOnServer {
    NSManagedObjectContext *mainContext = [[PAMDataStore standartDataStore] mainContext];
    for (PAMUserCore *userCore in [[PAMDataStore standartDataStore] fetchAllUsersInContext:mainContext]) {
        NSArray *arrayWithParties = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userCore.userId context:mainContext];
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

- (void)upDateOfflinePartiesByUserId:(NSInteger) userId {
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    NSArray * parties = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userId context:context];
    for (PAMPartyCore *party in parties) {
        if(!party.isLoaded) {
            [[PAMPartyMakerAPI standartPartyMakerAPI] writeParty:party creatorId:@(userId) callback:^(NSDictionary *response, NSError *error) {
                //NSLog(@"Party '%@' is loaded", party.name);
            }];
        }
    }
}

- (void)clearPartiesByUserId:(NSInteger) userId {
    [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
        NSArray * parties = [[PAMDataStore standartDataStore] fetchPartiesByUserId:userId context:backgroundContext];
        for (PAMPartyCore *party in parties) {
            [backgroundContext deleteObject:party];
        }
    } completion:^{
        
    }];
}

- (void)clearCoreData{
    UIApplication *application = [UIApplication sharedApplication];
    for (UILocalNotification *notification in [application scheduledLocalNotifications]) {
        [application cancelLocalNotification:notification];
    }

    [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backgroundContext) {
        NSArray * parties = [[PAMDataStore standartDataStore] fetchAllPartiesInContext:backgroundContext];
        NSLog(@"Will delete (%ld) paries", [parties count]);
        for (PAMPartyCore *party in parties) {
            [backgroundContext deleteObject:party];
        }
        
        NSArray * users = [[PAMDataStore standartDataStore] fetchAllUsersInContext:backgroundContext];
        NSLog(@"Will delete (%ld) users", [users count]);
        for (PAMUserCore *user in users) {
            [backgroundContext deleteObject:user];
        }
        
    } completion:^{
        NSLog(@"Deleted all users from core date");
    }];
}

#pragma mark - Core Data stack

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
