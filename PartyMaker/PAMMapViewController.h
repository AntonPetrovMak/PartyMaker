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

@interface PAMMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <PAMMapCoordinateDelegate> delegate;

@property (strong, nonatomic) NSDictionary *partyInfo;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) UIBarButtonItem *trashPartyPinItem;
@property (assign, nonatomic) BOOL isDraggablePin;

- (void)actionTrashPartyPin:(UIBarButtonItem *)sender;



@end
