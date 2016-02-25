
//
//  PAMMapViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMMapViewController.h"

@interface PAMMapViewController ()

@property(strong, nonatomic) MKPinAnnotationView *pinView;

@end

@implementation PAMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    self.trashPartyPinItem.enabled = NO;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPress:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.delegate = self;
    [self.mapView addGestureRecognizer:longPress];
    
    NSString *coordinateString = [self.partyInfo objectForKey:@"coordinate"];
    if(coordinateString.length) {
        NSArray* coordinate = [coordinateString componentsSeparatedByString:@";"];
        NSLog(@"%@", coordinate);
        if([coordinate count] == 2) {
            NSLog(@"%f , %f", [coordinate[0] floatValue], [coordinate[1] floatValue]);
            CLLocationCoordinate2D partyCoordinate = CLLocationCoordinate2DMake([coordinate[0] floatValue], [coordinate[1] floatValue]);
            [self addAnnotationWith:partyCoordinate];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated {
    
}

#pragma mark - Helpers
- (void)addAnnotationWith:(CLLocationCoordinate2D) coordinate {
    NSString *partyName = [self.partyInfo objectForKey:@"name"];
    PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:coordinate andTitle:partyName.length ? partyName : @"Party name"];
    [annotation setAddressToSubtitle];
    [self.mapView addAnnotation:annotation];
    self.trashPartyPinItem.enabled = YES;
}

#pragma mark - Action
- (void)actionTrashPartyPin:(UIBarButtonItem *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionMapCoordinate:nameLocation:)]) {
        [self.delegate performSelector:@selector(actionMapCoordinate:nameLocation:) withObject:@"" withObject:@""];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(IBAction)mapLongPress:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan && self.mapView.annotations.count <= 1) {
        CGPoint point = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D partyCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        [self addAnnotationWith:partyCoordinate];
    }
}

#pragma  mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion theRegion = self.mapView.region;
    theRegion.center = userLocation.location.coordinate;
    theRegion.span.longitudeDelta /=50;
    theRegion.span.latitudeDelta /=50;
    [self.mapView setRegion:theRegion animated:YES];
}

- (void) addLocation{
    [self.navigationController popViewControllerAnimated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[PAMMapAnnotation class]]) {
        /*PAMMapAnnotation *myLocation = (PAMMapAnnotation *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PAMMapAnnotation"];
        if(!annotationView) {
            annotationView = [myLocation annotatinView];
            annotationView.draggable = self.isDraggablePin;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [rightButton addTarget:nil action:@selector(addLocation) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightButton;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;*/
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinTintColor = [MKPinAnnotationView redPinColor];
            pinView.draggable = self.isDraggablePin;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
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
   fromOldState:(MKAnnotationViewDragState)oldState {
    PAMMapAnnotation *customAnnotation = (PAMMapAnnotation *)view.annotation;
    [customAnnotation setAddressToSubtitle];
    
    NSLog(@"newState: %lu oldState: %lu", newState, oldState);
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped");
    
    PAMMapAnnotation *customAnnotation = (PAMMapAnnotation *)view.annotation;
    NSString *locationString = [NSString stringWithFormat:@"%f;%f", customAnnotation.coordinate.latitude, customAnnotation.coordinate.longitude];
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionMapCoordinate:nameLocation:)]) {
        [self.delegate performSelector:@selector(actionMapCoordinate:nameLocation:) withObject:locationString withObject:customAnnotation.subtitle];
    }
}

@end
