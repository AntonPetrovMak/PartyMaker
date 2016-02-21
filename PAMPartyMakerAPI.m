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

-(void) writeParty:(PAMPartyCore *) party creatorId:(NSNumber *) creatorId callback:(void(^)(NSDictionary *response, NSError *error)) block {
    if(party.partyId){
        NSLog(@"party.partyId = %lld", party.partyId);
    }
    
    NSDictionary *dictionaryWithParty = @{  @"party_id": party.partyId ? @(party.partyId) : @"",
                                                @"name":party.name,
                                          @"start_time":@(party.startDate),
                                            @"end_time":@(party.endDate),
                                             @"logo_id":@(party.partyType),
                                             @"comment":party.partyDescription,
                                          @"creator_id":@(party.creatorParty.userId),
                                            @"latitude":@"",
                                           @"longitude":@""};
    
    NSMutableURLRequest *urlRequst = [self requestMethod:@"POST" methodAPI:@"addParty" parrametrs:dictionaryWithParty headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block([self serialize:data statusCode:[response valueForKey:@"statusCode"]],error);
                                }
                            }] resume];
}

-(void) allUsersWithCallback:(void(^)(NSDictionary *response, NSError *error)) block {

    NSMutableURLRequest *urlRequst = [self requestMethod:@"GET" methodAPI:@"allUsers" parrametrs:@{} headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block([self serialize:data statusCode:[response valueForKey:@"statusCode"]],error);
                                }
                            }] resume];
}

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

-(void) deletePartyById:(NSNumber *) partyId creator_id:(NSNumber *) creator_id callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSMutableURLRequest *urlRequst = [self requestMethod:@"GET" methodAPI:@"deleteParty" parrametrs:@{@"party_id":partyId, @"creator_id":creator_id} headers:nil];
    
    [[self.defaultSession dataTaskWithRequest:urlRequst
                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                if(block) {
                                    block([self serialize:data statusCode:[response valueForKey:@"statusCode"]],error);
                                }
                            }] resume];
}

-(void) deleteUserById:(NSNumber *) creator_id callback:(void(^)(NSDictionary *response, NSError *error)) block {
    NSMutableURLRequest *urlRequst = [self requestMethod:@"GET" methodAPI:@"deleteUser" parrametrs:@{@"creator_id":creator_id} headers:nil];
    
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

@end
