//
//  PAMAppDelegate.m
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMAppDelegate.h"
#import "PAMPartyMakerSDK.h"

@interface PAMAppDelegate ()

@end

@implementation PAMAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *attributes1 = @{ NSFontAttributeName:[UIFont fontWithName:@"MyriadPro-Bold" size:15],
                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes1];
    //PAMPartyMakerSDK *PM = [PAMPartyMakerSDK standartPartyMakerSDK];
//    [PM loginWithUserName:@"test" andPassword:@"test" callback:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@", response);
//    }];
//    [PM registerWithUserName:@"Anton" andPassword:@"12345" andEmail:@"Anton@gmail.com" callback:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@", response);
//    }];
//    [PM loginWithUserName:@"Anton" andPassword:@"12345" callback:^(NSDictionary *response, NSError *error) {
//        NSLog(@"%@", response);
//    }];
    
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
