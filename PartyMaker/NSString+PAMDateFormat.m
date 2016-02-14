//
//  NSString+PAMDateFormat.m
//  PartyMaker
//
//  Created by iMac309 on 14.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "NSString+PAMDateFormat.h"

@implementation NSString (PAMDateFormat)

+ (NSString *) stringHourAndMinutesWithInterval:(NSInteger) minutes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:minutes * 60]];
}

+ (NSString *) stringHourAndMinutesWithDate:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"HH:mm"];
    return [dateFormatter stringFromDate:[date dateByAddingTimeInterval:-7200]];;
}

+ (NSString *) stringPrityDateWithDate:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM.dd.yyyy"];
    return [dateFormatter stringFromDate:date];
}

@end
