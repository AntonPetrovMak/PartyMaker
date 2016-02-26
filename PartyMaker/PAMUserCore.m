//
//  PAMUserCore.m
//  PartyMaker
//
//  Created by iMac309 on 21.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMUserCore.h"
#import "PAMPartyCore.h"

@implementation PAMUserCore

+ (NSArray *)fetchUserByUserId:(NSInteger)userId context:(NSManagedObjectContext*)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %lld", (long long)userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return [fetchedObjects lastObject];
}

+ (NSArray *)fetchAllUsersInContext:(NSManagedObjectContext*) context {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    
    return fetchedObjects;
}

@end
