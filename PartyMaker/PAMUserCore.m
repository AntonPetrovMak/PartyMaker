//
//  PAMUserCore.m
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMUserCore.h"

@implementation PAMUserCore

+ (NSArray *)fetchUsersWithContext:(NSManagedObjectContext *) context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
 
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"usreId"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return fetchedObjects;
}

+ (PAMUserCore *)fetchUserWithContext:(NSManagedObjectContext *) context byUserId:(NSInteger) userId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMUserCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %ld", userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    
    //    for (PAMPartyCore* party in fetchedObjects) {
    //        NSLog(@"%@", party);
    //    }
    return [fetchedObjects lastObject];
}


@end
