//
//  PAMPartyCore.m
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMPartyCore.h"
#import "PAMUserCore.h"

@implementation PAMPartyCore

+ (PAMPartyCore *)fetchPartyWithContext:(NSManagedObjectContext *) context byPartyId:(NSInteger) partyId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"partyId == %ld", partyId];
    [fetchRequest setPredicate:predicate];
    

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
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

+ (NSArray *)fetchPartiesWithContext:(NSManagedObjectContext *) context byUserId:(NSInteger) userId {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %ld", userId];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    
//    for (PAMPartyCore* party in fetchedObjects) {
//        NSLog(@"%@", party);
//    }
    return fetchedObjects;
}

+ (NSArray *)fetchPartiesWithContext:(NSManagedObjectContext *) context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PAMPartyCore" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    
//    for (PAMPartyCore* party in fetchedObjects) {
//        NSLog(@"%@", party);
//    }
    return fetchedObjects;
}

+ (void)deletePartyWithCompletion:(void (^ _Nullable )(void))completion byPartyId:(NSInteger) partyId{
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] managedObjectContext];
    PAMPartyCore *partyObject = [PAMPartyCore fetchPartyWithContext:context byPartyId: partyId];
    [context deleteObject:partyObject];
    NSError *error = nil;
    [context save:&error];
    if (error) {
        NSLog(@" %s error %@", __PRETTY_FUNCTION__ ,error);
    }
    
    if (completion) {
        completion();
    }
}

+ (void) createParty:(PAMParty *) party withContext:(NSManagedObjectContext *) contex {
    PAMPartyCore *partyCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:contex];

    partyCore.name = party.partyName;
    partyCore.partyDescription = party.partyDescription;
    partyCore.partyId = party.partyId;
    partyCore.partyType = party.partyType;
    partyCore.startDate = party.partyStartDate;
    partyCore.endDate = party.partyEndDate;
    //partyCore.partyRelationship = ???
    
    NSError *error = nil;
    [contex save:&error];
    if (error) {
        NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\nId: %d\nName: %@ \nStart: %@ \nEnd: %@ \nType: %d \nDescription: %@\n\n",
            (int)self.partyId, self.name , [NSDate dateWithTimeIntervalSince1970:self.startDate], [NSDate dateWithTimeIntervalSince1970:self.endDate], (int)self.partyType, self.partyDescription];
}

@end
