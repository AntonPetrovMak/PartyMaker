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
- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion {
    [self.backgroundContext performBlock:^{
        writeBlock(self.backgroundContext);
        if (self.backgroundContext.hasChanges) {
            NSError *error = nil;
            [self.backgroundContext save:&error];
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

- (void) deleteAllParties {
    [self.backgroundContext performBlock:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PAMPartyCore"];
        NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
        
        NSError *deleteError = nil;
        [self.persistentStoreCoordinator executeRequest:delete withContext:self.backgroundContext error:&deleteError];
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

- (NSArray *)fetchAllParties {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:self.mainContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.mainContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return fetchedObjects;
}

#pragma mark - Fetches User
- (void) writeUserToCoreDataInBackroundThread:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion {
    NSManagedObjectContext *backroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [self.backgroundContext performBlock:^{
        writeBlock(backroundContext);
        
        NSError *error = nil;
        [backroundContext save:&error];
        if(error) {
            NSLog(@"%s, error happened - %@", __PRETTY_FUNCTION__, error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
}

- (NSArray *) fetchUserByUserId:(NSInteger)userId context:(NSManagedObjectContext*)context {
    
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


- (NSArray *) fetchAllUsers {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:self.mainContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.mainContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    for (PAMUserCore *userCore in fetchedObjects) {
        NSLog(@"User core name: %@",userCore.name);
    }
    return fetchedObjects;
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
            NSLog(@"%s",__PRETTY_FUNCTION__);
        }];
    }
}

- (void)applyMainContextContextChanges:(NSNotification *) notification {
    @synchronized (self) {
        [self.backgroundContext performBlock:^{
            [self.backgroundContext mergeChangesFromContextDidSaveNotification: notification];
            NSLog(@"%s",__PRETTY_FUNCTION__);
        }];
    }
}


@end
