//
//  PAMUsersPartiesViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 26.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMUsersPartiesViewController.h"

@interface PAMUsersPartiesViewController ()

@end

@implementation PAMUsersPartiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self addAllPartiesUser];
}

-(void)viewDidAppear:(BOOL)animated {
    
}

#pragma mark - Helpers

- (void) addAllPartiesUser {
    NSMutableArray *arrayWithAnnotation = [NSMutableArray new];
    for (PAMPartyCore *party in self.arrayWithParties) {
        NSString *coordinateString = party.longitude;
        if(coordinateString.length) {
            NSArray* coordinate = [coordinateString componentsSeparatedByString:@";"];
            NSLog(@"%@", coordinate);
            if([coordinate count] == 2) {
                NSLog(@"%f , %f", [coordinate[0] floatValue], [coordinate[1] floatValue]);
                CLLocationCoordinate2D partyCoordinate = CLLocationCoordinate2DMake([coordinate[0] floatValue], [coordinate[1] floatValue]);
                PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:partyCoordinate andTitle:party.name.length ? party.name : @"Party name"];
                [annotation setAddressToSubtitle];
                [arrayWithAnnotation addObject: annotation];
            }
        }
    }
    [self.mapView addAnnotations:arrayWithAnnotation];
}

#pragma  mark - MKMapViewDelegate

- (void) zoomAnnotationOnMap {
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CLLocationCoordinate2D location = annotation.coordinate;
        MKMapPoint center = MKMapPointForCoordinate(location);
        static double delta = 20000;
        MKMapRect rect = MKMapRectMake(center.x - delta, center.y - delta, delta * 2, delta * 2);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(50, 50, 50, 50)
                           animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self zoomAnnotationOnMap];
}

- (void) infoParty{
    //[self.navigationController popViewControllerAnimated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[PAMMapAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinTintColor = [MKPinAnnotationView redPinColor];
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            [rightButton addTarget:nil action:@selector(infoParty) forControlEvents:UIControlEventTouchUpInside];
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
   fromOldState:(MKAnnotationViewDragState)oldState {
    PAMMapAnnotation *customAnnotation = (PAMMapAnnotation *)view.annotation;
    [customAnnotation setAddressToSubtitle];
    
    NSLog(@"newState: %lu oldState: %lu", (unsigned long)newState, (unsigned long)oldState);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped");
    
}




@end
