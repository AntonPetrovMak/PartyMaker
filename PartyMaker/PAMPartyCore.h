//
//  PAMPartyCore.h
//  PartyMaker
//
//  Created by Petrov Anton on 17.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PAMDataStore.h"
#import "PAMParty.h"
#import "PAMUserCore.h"

@class PAMUserCore;

NS_ASSUME_NONNULL_BEGIN

@interface PAMPartyCore : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "PAMPartyCore+CoreDataProperties.h"
