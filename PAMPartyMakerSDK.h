//
//  PAMPartyMakerSDK.h
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAMPartyMakerSDK : NSObject

+ (PAMPartyMakerSDK *) standartPartyMakerSDK;

-(void) loginWithUserName:(NSString *) _username andPassword:(NSString *) _pass callback:(void(^)(NSDictionary *response, NSError *error)) block;
-(void) registerWithUserName:(NSString *) _username andPassword:(NSString *) _pass andEmail:(NSString *) _email callback:(void(^)(NSDictionary *response, NSError *error)) block;
@end
