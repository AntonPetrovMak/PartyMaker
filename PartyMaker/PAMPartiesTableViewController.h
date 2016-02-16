//
//  PAMPartiesTableViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMDataStore.h"
#import "PAMUser.h"
#import "PAMParty.h"
#import "PAMPartyTableCell.h"
#import "PAMShowPartyViewController.h"
#import "NSString+PAMDateFormat.h"
#import "PAMPartyMakerSDK.h"

@interface PAMPartiesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)logOffUser:(UIBarButtonItem *)sender;

@end
