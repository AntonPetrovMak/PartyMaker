//
//  PAMPartyMakerSDK.m
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartyMakerAPI.h"

static NSString* APIURLLink = @"http://itworksinua.km.ua/party/";

@interface PAMPartyMakerAPI ()

@property(strong, nonatomic) NSURLSession *defaultSession;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation PAMPartyMakerAPI

#pragma mark - API
+ (PAMPartyMakerAPI *) standartPartyMakerAPI {
    static PAMPartyMakerAPI *dataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataStore = [[PAMPartyMakerAPI alloc] init];
        if(dataStore)[dataStore configureSessionAndAPI];
    });
    return dataStore;
}

-(void)configureSessionAndAPI {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 5.0;
    sessionConfig.timeoutIntervalForResource = 10.0;
    sessionConfig.allowsCellularAccess = NO;
    self.defaultSession = [NSURLSession sessionWithConfiguration:sessionConfig];
}

-(NSMutableURLRequest *) requestMethod:(NSString *) method methodAPI:(NSString *) methodAPI parrametrs:(NSDictionary *) parrametrs headers:(NSDictionary *) headers {
    NSString *stringWithURL = [APIURLLink stringByAppendingString:methodAPI];
    stringWithURL = [stringWithURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:stringWithURL];
    
    NSMutableURLRequest *urlRequst = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequst setHTTPMethod:[method uppercaseString]];
    
    if([[method uppercaseString] isEqualToString:@"GET"]){
        stringWithURL = [stringWithURL stringByAppendingString:@"?"];
        for (NSString *key in [parrametrs allKeys]) {
            stringWithURL = [stringWithURL stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key ,[parrametrs objectForKey:key]]];
        }
        stringWithURL = [stringWithURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [urlRequst setURL:[NSURL URLWithString:stringWithURL]];
        return urlRequst;
    } else if([[method uppercaseString] isEqualToString:@"POST"]) {
        NSString *str = @"";
        for (NSString *key in [parrametrs allKeys]) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key ,[parrametrs objectForKey:key]]];
        }
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSData *reqData = [str dataUsingEncoding:NSUTF8StringEncoding];
        [urlRequst setHTTPBody:reqData];
        return urlRequst;
    }
    return nil;
}

-(void) loginWithUserName:(NSString *) _username andPassword:(NSString *) _pass callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSMutableURLRequest *urlRequst = [self requestMethod:@"GET" methodAPI:@"login" parrametrs:@{@"name":_username, @"password":_pass} headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block ([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
                                }
                            }] resume];
}

-(void) partiesWithCreatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSMutableURLRequest *urlRequst = [self requestMethod:@"GET" methodAPI:@"party" parrametrs:@{@"creator_id":creatorId} headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                           completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                               if(block) {
                                   block([self serialize:data statusCode:[response valueForKey:@"statusCode"]],error);
                               }
                           }] resume];
}

/*-(void) writeParty:(PAMParty *) party withCreatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSDictionary *dictionaryWithParty = @{  @"party_id":@"",
                                                @"name":party.partyName,
                                          @"start_time":[NSString stringWithFormat:@"%ld",party.partyStartDate],
                                            @"end_time":[NSString stringWithFormat:@"%ld",party.partyEndDate],
                                             @"logo_id":@(party.partyType),
                                             @"comment":party.partyDescription,
                                          @"creator_id":creatorId,
                                            @"latitude":@"",
                                           @"longitude":@""};
    
    NSMutableURLRequest *urlRequst = [self requestMethod:@"POST" methodAPI:@"addParty" parrametrs:dictionaryWithParty headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block([self serialize:data statusCode:[response valueForKey:@"statusCode"]],error);
                                }
                            }] resume];
}*/

-(void) registerWithUserName:(NSString *) _username andPassword:(NSString *) _pass andEmail:(NSString *) _email callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSMutableURLRequest *urlRequst = [self requestMethod:@"POST"
                                               methodAPI:@"register"
                                              parrametrs:@{@"name":_username, @"password":_pass, @"email": _email}
                                                 headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block ([self serialize:data statusCode:(NSNumber *)[response valueForKey:@"statusCode"]], error);
                                }
                            }] resume];
}

-(void) deletePartyById:(NSNumber *) partyId callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSMutableURLRequest *urlRequst = [self requestMethod:@"GET" methodAPI:@"deleteParty" parrametrs:@{@"party_id":partyId} headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block([self serialize:data statusCode:[response valueForKey:@"statusCode"]],error);
                                }
                            }] resume];
}

- (NSDictionary *) serialize:(NSData *) _data statusCode:(NSNumber *) _statusCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_statusCode)
        [dict setValue:_statusCode forKey:@"statusCode"];
    else
        [dict setValue:@505 forKey:@"statusCode"];
    id jsonArray;
    if (_data) jsonArray = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:nil];
    if (!jsonArray) jsonArray = [NSNull null];
    [dict setValue:jsonArray forKey:@"response"];
    return dict;
}

#pragma mark - Fetches

#pragma mark - Fetches User
- (NSArray *)fetchUserWithName:(NSString *) name email:(NSString *)email userId:(NSInteger) userId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND email == %@ AND userId == %ld", name, email, userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return [fetchedObjects lastObject];
}

- (void) performWriteOperation:(void (^)(NSManagedObjectContext*))writeBlock completion:(void(^)())completion {
    [self.managedObjectContext performBlock:^{
        writeBlock(self.managedObjectContext);
        
        if (self.managedObjectContext.hasChanges) {
            NSError *error = nil;
            [self.managedObjectContext save:&error];
            NSLog(@"%s, error happened - %@", __PRETTY_FUNCTION__, error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }];
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PAMPartyMakerAPI" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PAMPartyMakerAPI.sqlite"];
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
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSPrivateQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}



@end
