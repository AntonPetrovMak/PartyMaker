//
//  PAMMapViewController.h
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PAMMapAnnotation.h"
#import "PAMPartyCore.h"


@protocol PAMMapCoordinateDelegate <NSObject>
- (void)actionMapCoordinate:(NSString *) location nameLocation:(NSString *) namaLocation;
@end

@interface PAMMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) PAMPartyCore *party;

@property (weak, nonatomic) id <PAMMapCoordinateDelegate> delegate;

@end
