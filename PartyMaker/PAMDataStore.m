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
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData: oldData];
        NSMutableArray *mattay = [[NSMutableArray alloc] initWithArray:array];
        return mattay;
    }
    return [[NSMutableArray alloc] init];
}


- (void) writePartiesToPlist:(NSMutableArray *) arrayParties {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    
    NSArray *sortedParties = [arrayParties sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"partyStartDate" ascending: true],
                                                                         [NSSortDescriptor sortDescriptorWithKey:@"partyName" ascending: true]]];
    
    NSData* newData = [NSKeyedArchiver archivedDataWithRootObject: sortedParties];
    [newData writeToFile:documentsPathWithFile atomically:YES];
}

- (void) writePartyToPlist:(PAMParty *) party {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *documentsPathWithFile = [documentsPath stringByAppendingPathComponent:@"logs.plist"];
    
    NSMutableArray *arrayParties = [self arrayWithParties];
    
    if (!arrayParties.count) {
        NSString *logsPlistPath = [[NSBundle mainBundle] pathForResource:@"logs" ofType:@"plist"];
        [fileManager copyItemAtPath:logsPlistPath toPath:documentsPathWithFile error:&error];
    }
    [arrayParties addObject:party];
    [self writePartiesToPlist:arrayParties];
}

@end
