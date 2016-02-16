//
//  PAMUser.h
//  PartyMaker
//
//  Created by Petrov Anton on 16.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAMUser : NSObject <NSCoding>

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* email;
@property(assign, nonatomic) int userId;

-(instancetype) initWithName:(NSString *) name email:(NSString *) email userId:(int) userId;

@end
