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
        return [NSKeyedUnarchiver unarchiveObjectWithData: oldData];
    }
    return [[NSMutableArray alloc] init];
}

- (void) writePartiesToPlist:(PAMNewViewController *) viewController {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    
    NSCalendar *calendar =[NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                               fromDate:viewController.partyDate];
    
    NSInteger intervale = ((components.hour-2) * 60 * 60) + (components.minute * 60) + components.second;
    
    NSDate *partyDate = [viewController.partyDate dateByAddingTimeInterval:-intervale];
    
    PAMParty *party = [[PAMParty alloc] initWithName:viewController.partyNameTextField.text
                                           startDate:[partyDate dateByAddingTimeInterval:viewController.startSlider.value*60]
                                             endDate:[partyDate dateByAddingTimeInterval:viewController.endSlider.value*60]
                                            paryType:viewController.typeEventPageControl.currentPage
                                         description:viewController.partyDescription.text];
    
    NSMutableArray *arrayPartyes = [self arrayWithParties];
    
    if (!arrayPartyes.count) {
        NSString *logsPlistPath = [[NSBundle mainBundle] pathForResource:@"logs" ofType:@"plist"];
        [fileManager copyItemAtPath:logsPlistPath toPath:documentsPathWithFile error:&error];
    }
    [arrayPartyes addObject:party];
    NSLog(@"%@",arrayPartyes);
    NSData* newData = [NSKeyedArchiver archivedDataWithRootObject: arrayPartyes];
    [newData writeToFile:documentsPathWithFile atomically:YES];
}

@end
