//
//  PAMAppDelegate.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAppDelegate.h"
#import "PAMPartyMakerAPI.h"
#import "PAMLocalNotification.h"
#import "PAMShowPartyViewController.h"
#import "PAMPartyCore.h"
#import "PAMDataStore.h"
#import "Reachability.h"
#import "PAMUserCore.h"
#import "PAMPartyCore.h"

@interface PAMAppDelegate ()

@end

@implementation PAMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [[PAMDataStore standartDataStore] upDateUsersWithPartiesFromServer];
    
    NSDictionary *attributes1 = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes1];

    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UITabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = tabBar;
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void) application:(UIApplication *) application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    /*if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UITabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = tabBar;
        
        NSDictionary *data = [notification userInfo];
        NSInteger partyId = [[data objectForKey:@"party_id"] integerValue];
        
        PAMShowPartyViewController *showView = [storyboard instantiateViewControllerWithIdentifier:@"PAMShowPartyViewController"];
        showView.party = (PAMPartyCore*)[PAMPartyCore fetchPartyByPartyId:partyId
                                                                  context:[[PAMDataStore standartDataStore] mainContext]];
        [tabBar.navigationController pushViewController:showView animated:YES];
        [self.window makeKeyAndVisible];
    }*/
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}



@end
