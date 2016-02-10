//
//  PAMDataStore.h
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAMParty.h"
#import "PAMNewViewController.h"
@class PAMNewViewController;

@interface PAMDataStore : NSObject

+ (PAMDataStore *) standartDataStore;

- (void) writePartiesToPlist:(PAMNewViewController *) viewController;
- (NSMutableArray *) arrayWithParties;

@end
