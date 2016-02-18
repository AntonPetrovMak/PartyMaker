//
//  PAMUserCore+CoreDataProperties.h
//  PartyMaker
//
//  Created by Petrov Anton on 18.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PAMUserCore.h"

NS_ASSUME_NONNULL_BEGIN

@interface PAMUserCore (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *name;
@property (nonatomic) int64_t userId;
@property (nonatomic) BOOL isLoaded;
@property (nullable, nonatomic, retain) NSSet<PAMPartyCore *> *parties;

@end

@interface PAMUserCore (CoreDataGeneratedAccessors)

- (void)addPartiesObject:(PAMPartyCore *)value;
- (void)removePartiesObject:(PAMPartyCore *)value;
- (void)addParties:(NSSet<PAMPartyCore *> *)values;
- (void)removeParties:(NSSet<PAMPartyCore *> *)values;

@end

NS_ASSUME_NONNULL_END
