//
//  PAMAppDelegate.h
//  PartyMaker
//
//  Created by Petrov Anton on 03.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PAMAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

