//
//  PAMAppDelegate.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAppDelegate.h"
#import "PAMPartyMakerSDK.h"
#import "PAMPartyCore.h"
#import "PAMDataStore.h"

@interface PAMAppDelegate ()

@end

@implementation PAMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *attributes1 = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes1];
    
    NSManagedObjectContext *moc = [[PAMDataStore standartDataStore] managedObjectContext];
    
    
    PAMPartyCore *party = [NSEntityDescription insertNewObjectForEntityForName:@"PAMPartyCore" inManagedObjectContext:moc];
    
    party.name = @"fmljsngvkhfdnkvjfddfkjanddjsnvjndfbnvdfjnvbdfjkvdkjnv";
    
    NSError *error = nil;
    [moc save:&error];
    if (error) {
        NSLog(@"%s error saving context %@", __PRETTY_FUNCTION__, error);
    }

    
    
//    PAMPartyMakerSDK *partyMakerSDK = [PAMPartyMakerSDK standartPartyMakerSDK];
//    [partyMakerSDK partiesWithCreatorId:@56 callback:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@",response);
//    }];
    
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UITabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.rootViewController = tabBar;
//        [self.window makeKeyAndVisible];
//    }
    return YES;
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
