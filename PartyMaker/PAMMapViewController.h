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
- (void)actionMapCoordinate:(NSString *) location nameLocation:(NSString *) nameLocation;
@end

typedef NS_ENUM(NSInteger, PAMMapStateType) {
    PAMMapStateRead = 1,
    PAMMapStateWrite = 2
};

@interface PAMMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <PAMMapCoordinateDelegate> delegate;

@property (assign, nonatomic) PAMMapStateType typeMap;

@property (strong, nonatomic) NSDictionary *partyInfo;
@property (strong, nonatomic) NSArray *arrayWithParties;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)actionTrashPartyPin:(UIBarButtonItem *)sender;


@end
