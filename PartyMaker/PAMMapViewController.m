
//
//  PAMMapViewController.m
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMMapViewController.h"
#import "PAMShowPartyViewController.h"

@interface PAMMapViewController ()

@property (weak, nonatomic) UIBarButtonItem *trashPartyPinItem;
@property (assign, nonatomic) BOOL isDraggablePin;

@end

@implementation PAMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (self.typeMap) {
        case PAMMapStateRead: {
            [self loadMapForRead];
        } break;
        case PAMMapStateWrite: {
            [self loadMapForWrite];
        } break;
            
        default:
            NSAssert1(NO, @"No typeMap", nil);
            break;
    }
}

- (void)loadMapForRead {
    self.isDraggablePin = NO;
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

- (void)loadMapForWrite {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPress:)];
    longPress.minimumPressDuration = 0.5f;
    longPress.delegate = self;
    [self.mapView addGestureRecognizer:longPress];
    
    UIBarButtonItem *treshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                               target:self
                                                                               action:@selector(actionTrashPartyPin:)];
    self.isDraggablePin = YES;
    self.trashPartyPinItem = treshItem;
    self.trashPartyPinItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = self.trashPartyPinItem;
    
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
    self.trashPartyPinItem.enabled = YES;
    NSString *partyName = [self.partyInfo objectForKey:@"name"];
    PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:coordinate andTitle:partyName.length ? partyName : @"Party name"];
    [annotation setAddressToSubtitle];
    [self.mapView addAnnotation:annotation];
}

- (void)zoomAnnotationOnMap {
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
                        edgePadding:UIEdgeInsetsMake(30, 30, 30, 30)
                           animated:YES];
}

#pragma mark - Action
- (void)actionTrashPartyPin:(UIBarButtonItem *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionMapCoordinate:nameLocation:)]) {
        [self.delegate performSelector:@selector(actionMapCoordinate:nameLocation:) withObject:@"" withObject:@""];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCalloutAdd {
    [self.navigationController popViewControllerAnimated:YES];
}






- (void)actionCalloutInfo {
    PAMShowPartyViewController *showView = [self.storyboard instantiateViewControllerWithIdentifier:@"PAMShowPartyViewController"];
    PAMPartyCore *party = (PAMPartyCore *)[self.arrayWithParties objectAtIndex:1];
    showView.party = party;
    [self.navigationController pushViewController:showView animated:YES];
}







#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (IBAction)mapLongPress:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if(self.mapView.annotations.count >= 1) {
            id userLocation = [self.mapView userLocation];
            NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
            if ( userLocation != nil ) {
                [pins removeObject:userLocation];
            }
            
            [self.mapView removeAnnotations:pins];
        }
        CGPoint point = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D partyCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
        [self addAnnotationWith:partyCoordinate];
    }
}

#pragma  mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self zoomAnnotationOnMap];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if([annotation isKindOfClass:[PAMMapAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.pinTintColor = [MKPinAnnotationView redPinColor];
            pinView.draggable = self.isDraggablePin;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            UIButton *rightButton;
            switch (self.typeMap) {
                case PAMMapStateRead: {
                    rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
                    [rightButton addTarget:nil action:@selector(actionCalloutInfo) forControlEvents:UIControlEventTouchUpInside];
                } break;
                case PAMMapStateWrite: {
                    rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
                    [rightButton addTarget:nil action:@selector(actionCalloutAdd) forControlEvents:UIControlEventTouchUpInside];
                } break;
            }
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
    if(self.typeMap == PAMMapStateWrite) {
        PAMMapAnnotation *customAnnotation = (PAMMapAnnotation *)view.annotation;
        NSString *locationString = [NSString stringWithFormat:@"%f;%f", customAnnotation.coordinate.latitude, customAnnotation.coordinate.longitude];
        if(self.delegate && [self.delegate respondsToSelector:@selector(actionMapCoordinate:nameLocation:)]) {
            [self.delegate performSelector:@selector(actionMapCoordinate:nameLocation:) withObject:locationString withObject:customAnnotation.subtitle];
        }
    }
}

@end
