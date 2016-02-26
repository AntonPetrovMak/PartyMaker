//
//  PAMLocalNotification.h
//  PartyMaker
//
//  Created by iMac309 on 25.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAMPartyCore.h"

@interface PAMLocalNotification : UILocalNotification

+ (void)notificationForRarty:(PAMPartyCore *) party;
+ (void)notificationForRarty;
+ (void)removeAllNotifications;
+ (void)removePartyNotifications:(NSInteger ) partyId;

@end
