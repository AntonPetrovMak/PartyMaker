//
//  PAMUsersPartiesViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 26.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PAMMapAnnotation.h"
#import "PAMPartyCore.h"

@interface PAMUsersPartiesViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) NSArray *arrayWithParties;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end