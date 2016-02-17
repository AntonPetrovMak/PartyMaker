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

+ (PAMPartyCore *) fetchWithContext:(NSManagedObjectContext *) context {
    NSFetchRequest *fetch = [NSFetchRequest new];
    fetch.entity = [NSEntityDescription entityForName:@"PMRParty" inManagedObjectContext:context];
    fetch.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"fff"];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetch error:&error];
    if ( error ) {
        NSLog(@"PMRPartyManagedObject pmr_fetchPartyWithName: failed with error %@", error);
    }
    return [fetchedObjects lastObject];
}

+ (void) createPartyWithContext:(NSManagedObjectContext *) contex {
    PAMPartyCore *party = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:contex];
    
    party.name = @"fmljsngvkhfdnkvjfddfkjanddjsnvjndfbnvdfjnvbdfjkvdkjnv";
    
    NSError *error = nil;
    [contex save:&error];
    if (error) {
        NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
    }
}

@end
