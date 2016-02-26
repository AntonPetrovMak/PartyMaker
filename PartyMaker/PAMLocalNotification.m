//
//  PAMLocalNotification.m
//  PartyMaker
//
//  Created by iMac309 on 25.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMLocalNotification.h"

@implementation PAMLocalNotification

+ (void)notificationForRarty:(PAMPartyCore *) party {
    if(party.startDate > [[[NSDate date] dateByAddingTimeInterval:3600] timeIntervalSince1970]) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"Party time!";
        localNotification.alertAction = [NSString stringWithFormat:@"%@ is about to begin!", party.name];
        NSLog(@"Add party natification: %@",[[NSDate dateWithTimeIntervalSince1970:party.startDate] dateByAddingTimeInterval:-3600]);
        localNotification.fireDate = [[NSDate dateWithTimeIntervalSince1970:party.startDate] dateByAddingTimeInterval:-3600];
        localNotification.userInfo = @{ @"party_id" : @(party.partyId) };
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.repeatInterval = 0;
        localNotification.category = @"LocalNotificationDefaultCategory";
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        UIMutableUserNotificationAction *doneAction = [[UIMutableUserNotificationAction alloc] init];
        doneAction.identifier = @"doneActionIdentifier";
        doneAction.destructive = NO;
        doneAction.title = @"Mark done";
        doneAction.activationMode = UIUserNotificationActivationModeBackground;
        doneAction.authenticationRequired = NO;
        
        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = @"LocalNotificationDefaultCategory";
        [category setActions:@[doneAction] forContext:UIUserNotificationActionContextMinimal];
        [category setActions:@[doneAction] forContext:UIUserNotificationActionContextDefault];
        NSSet *categories = [[NSSet alloc] initWithArray:@[category]];
        UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings
                                                            settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
}

+ (void)notificationForRarty {

    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Party time!";
    localNotification.alertAction = [NSString stringWithFormat:@" is about to begin!"];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:10];
    localNotification.userInfo = @{ @"party_id" : @(22222) };
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.repeatInterval = 0;
    localNotification.category = @"LocalNotificationDefaultCategory";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    UIMutableUserNotificationAction *doneAction = [[UIMutableUserNotificationAction alloc] init];
    doneAction.identifier = @"doneActionIdentifier";
    doneAction.destructive = NO;
    doneAction.title = @"Mark done";
    doneAction.activationMode = UIUserNotificationActivationModeBackground;
    doneAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"LocalNotificationDefaultCategory";
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextMinimal];
    [category setActions:@[doneAction] forContext:UIUserNotificationActionContextDefault];
    NSSet *categories = [[NSSet alloc] initWithArray:@[category]];
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings
                                                        settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
}

+ (void)removeAllNotifications {
    UIApplication *application = [UIApplication sharedApplication];
    for (UILocalNotification *notification in [application scheduledLocalNotifications]) {
        [application cancelLocalNotification:notification];
    }
}

+ (void)removePartyNotifications:(NSInteger ) partyId {
    UIApplication *application = [UIApplication sharedApplication];
    for (UILocalNotification *notification in [application scheduledLocalNotifications]) {
        if(partyId == [[notification.userInfo objectForKey:@"party_id"] integerValue]) {
            [application cancelLocalNotification:notification];
            NSLog(@"delete notification for party id: %ld", (long)partyId);
        }
    }
}

@end
