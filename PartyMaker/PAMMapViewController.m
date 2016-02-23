
//
//  PAMMapViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMMapViewController.h"

@interface PAMMapViewController ()

@end

@implementation PAMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapPress:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.delegate = self;
    [self.mapView addGestureRecognizer:longPress];
}

-(void)viewDidAppear:(BOOL)animated {

}
#pragma makr - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


-(IBAction)mapPress:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan ) {
        CGPoint point = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:tapPoint];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"CustomPinAnnotationView"];
    pinView.pinTintColor = [MKPinAnnotationView redPinColor];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    return pinView;
}

@end
