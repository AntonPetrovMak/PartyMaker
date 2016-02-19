//
//  PAMAppDelegate.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAppDelegate.h"
#import "PAMPartyMakerAPI.h"
#import "PAMPartyCore.h"
#import "PAMUserCore.h"
#import "PAMDataStore.h"

@interface PAMAppDelegate ()

@end

@implementation PAMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *attributes1 = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes1];
    
    //NSManagedObjectContext *context = [[PAMDataStore standartDataStore] managedObjectContext];
    //[PAMPartyCore fetchPartiesWithContext: context];
    //[PAMPartyCore deletePartyWithCompletion:nil byPartyId:12];
    //[PAMPartyCore fetchPartiesWithContext: context];
    //[[PAMDataStore standartDataStore] fetchAllUsers];
//    [[PAMDataStore standartDataStore] performWriteOperation:^(NSManagedObjectContext *backroundContext) {
//        PAMUserCore *userCore = [NSEntityDescription insertNewObjectForEntityForName:@"PAMUserCore" inManagedObjectContext:backroundContext];
//        userCore.name = @"Koly";
//        userCore.email = @"Koly@gmail.com";
//        userCore.userId = 196;
//        userCore.isLoaded = YES;
//    } completion:^{
//        
//    }];
    
//    PAMParty *party = [[PAMParty alloc] initWithPartyId:88
//                                                   name:@"Test party 4"
//                                              startDate:1
//                                                endDate:120*1000
//                                               paryType:4
//                                            description:@"description party test 4"];
//    [PAMPartyCore createParty:party withContext:context];
    
    
    
//    PAMPartyMakerSDK *partyMakerSDK = [PAMPartyMakerSDK standartPartyMakerSDK];
//    [partyMakerSDK partiesWithCreatorId:@56 callback:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@",response);
//    }];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UITabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = tabBar;
        [self.window makeKeyAndVisible];
    }
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
