//
//  PAMPartyCore.m
//  PartyMaker
//
//  Created by iMac309 on 21.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartyCore.h"
#import "PAMUserCore.h"

@implementation PAMPartyCore

+ (NSArray *)fetchPartyByPartyId:(NSInteger) partyId context:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partyId == %ld", partyId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return [fetchedObjects lastObject];
}

+ (NSArray *)fetchPartiesByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creatorParty.userId == %ld", userId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return fetchedObjects;
}

+ (NSArray *)fetchPartiesWithLocationByUserId:(NSInteger) userId context:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"creatorParty.userId == %ld && longitude != %@", userId, @""];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    return fetchedObjects;
}

+ (NSArray *)fetchAllPartiesInContext:(NSManagedObjectContext*) context{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creatorParty.userId"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    /*for (PAMPartyCore *party in fetchedObjects) {
     NSLog(@"Creator party: %@ Name party: %@", party.creatorParty.name, party.name);
     }*/
    return fetchedObjects;
}

@end
