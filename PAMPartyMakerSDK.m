//
//  PAMPartyMakerSDK.m
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartyMakerSDK.h"

static NSString* APIURLLink = @"http://itworksinua.km.ua/party/";

@interface PAMPartyMakerSDK ()
@property(strong, nonatomic) NSURLSession *defaultSession;
@end

@implementation PAMPartyMakerSDK

#pragma mark - init
+ (PAMPartyMakerSDK *) standartPartyMakerSDK {
    static PAMPartyMakerSDK *dataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataStore = [[PAMPartyMakerSDK alloc] init];
        if(dataStore)[dataStore configureSessionAndAPI];
    });
    return dataStore;
}

-(void)configureSessionAndAPI {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 30.0;
    sessionConfig.timeoutIntervalForResource = 60.0;
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
