
//
//  PAMMapViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMMapViewController.h"

@interface PAMMapViewController ()

@property(strong, nonatomic) CLGeocoder* geocoder;

@end

@implementation PAMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.geocoder = [[CLGeocoder alloc] init];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPress:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.delegate = self;
    [self.mapView addGestureRecognizer:longPress];
}

-(void)viewDidAppear:(BOOL)animated {

}

#pragma makr - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}


-(IBAction)mapLongPress:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        CGPoint point = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:tapPoint];
        
        if([self.geocoder isGeocoding]) {
            [self.geocoder cancelGeocode];
        }
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
        
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placeMark = [placemarks firstObject];
                annotation.title = @"";
                annotation.subtitle = [NSString stringWithFormat:@"%@, %@",placeMark.locality, placeMark.thoroughfare];
            }
        }];
        
        
        [self.mapView addAnnotation:annotation];
    }
}

#pragma  mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion theRegion = self.mapView.region;
    theRegion.center = userLocation.location.coordinate;
    theRegion.span.longitudeDelta /=70;
    theRegion.span.latitudeDelta /=70;
    [self.mapView setRegion:theRegion animated:YES];
}

- (void) addLocation {
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[PAMMapAnnotation class]]) {
//        PAMMapAnnotation *myLocation = (PAMMapAnnotation *)annotation;
//        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PAMMapAnnotation"];
//        if(!annotationView) {
//            annotationView = [myLocation annotatinView];
//            annotationView.canShowCallout = YES;
//            annotationView.draggable = YES;
//        } else {
//            annotationView.annotation = annotation;
//        }
//        return annotationView;
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinTintColor = [MKPinAnnotationView redPinColor];
            pinView.draggable = YES;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(10_9, 4_0) {
    NSLog(@"newState: %lu oldState: %lu", newState, oldState);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped");
}

@end
