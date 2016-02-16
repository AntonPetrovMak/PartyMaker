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

+ (NSDate *) getHumanDate: (NSString *) strDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    strDate = [NSString stringWithFormat:@"%@ -0000",[strDate substringToIndex:20]];
    return [dateFormat dateFromString:strDate];
}

@end
