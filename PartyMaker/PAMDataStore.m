//
//  PAMDataStore.m
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMDataStore.h"

@implementation PAMDataStore

+ (PAMDataStore *) standartDataStore {
    static PAMDataStore *dataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataStore = [[PAMDataStore alloc] init];
    });
    return dataStore;
}

- (NSMutableArray *) arrayWithParties {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    if ([fileManager fileExistsAtPath:documentsPathWithFile]) {
        NSData *oldData =[NSData dataWithContentsOfFile:documentsPathWithFile];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData: oldData];
        NSMutableArray *mattay = [[NSMutableArray alloc] initWithArray:array];
        return mattay;
    }
    return [[NSMutableArray alloc] init];
}

- (void) writePartiesToPlist:(NSMutableArray *) arrayParties {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    
    NSArray *sortedParties = [arrayParties sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"partyStartDate" ascending: true],
                                                                         [NSSortDescriptor sortDescriptorWithKey:@"partyName" ascending: true]]];
    
    NSData* newData = [NSKeyedArchiver archivedDataWithRootObject: sortedParties];
    [newData writeToFile:documentsPathWithFile atomically:YES];
}

- (void) writePartyToPlist:(PAMParty *) party {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    
    NSMutableArray *arrayParties = [self arrayWithParties];
    
    if (!arrayParties.count) {
        NSString *logsPlistPath = [[NSBundle mainBundle] pathForResource:@"logs" ofType:@"plist"];
        [fileManager copyItemAtPath:logsPlistPath toPath:documentsPathWithFile error:&error];
    }
    [arrayParties addObject:party];
    [self writePartiesToPlist:arrayParties];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PAMCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


@end
