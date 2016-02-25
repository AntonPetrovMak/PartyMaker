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
    if(strDate.length >24) {
        strDate = [NSString stringWithFormat:@"%@ -0000",[strDate substringToIndex:20]];
        return [dateFormat dateFromString:strDate];
    }
    return [NSDate date];
}

+ (NSString *)escapeSpecialCharactersWithString:(NSString *) string {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"'"];
    NSArray *components = [string componentsSeparatedByCharactersInSet:characterSet];
    if([components count] > 1) {
        NSString *newString = @"";
        for (int i =0; i < [components count] - 1; i++) {
            newString = [NSString stringWithFormat:@"%@%@\\`",newString, components[i]];
        }
        newString = [NSString stringWithFormat:@"%@%@",newString, [components lastObject]];
        return newString;
    }
    return string;
}

+ (NSString *)removeEscapeSpecialCharactersWithString:(NSString *) string {
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"\\"];
    NSArray *components = [string componentsSeparatedByCharactersInSet:characterSet];
    if([components count] > 1) {
        NSString *newString = @"";
        for (NSString *str in components) {
            newString = [NSString stringWithFormat:@"%@%@",newString, str];
        }
        return newString;
    }
    return string;
}

@end
