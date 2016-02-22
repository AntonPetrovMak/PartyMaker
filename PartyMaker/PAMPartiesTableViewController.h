//
//  PAMPartiesTableViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 10.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMPartyTableCell.h"
#import "PAMShowPartyViewController.h"
#import "NSString+PAMDateFormat.h"
#import "PAMPartyMakerAPI.h"
#import "PAMPartyCore.h"
#import "PAMDataStore.h"
#import "Reachability.h"

@interface PAMPartiesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
- (IBAction)logOffUser:(UIBarButtonItem *)sender;

@property (nonatomic) Reachability *wifiReachability;
@end
