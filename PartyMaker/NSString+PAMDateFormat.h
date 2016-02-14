//
//  NSString+PAMDateFormat.h
//  PartyMaker
//
//  Created by iMac309 on 14.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PAMDateFormat)

+ (NSString *) stringHourAndMinutesWithInterval:(NSInteger) minutes;
+ (NSString *) stringHourAndMinutesWithDate:(NSDate *) date;
+ (NSString *) stringPrityDateWithDate:(NSDate *) date;

@end
