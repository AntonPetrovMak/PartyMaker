
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
@property (strong, nonatomic) PAMMapAnnotation *currentAnnotation;

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
        case PAMMapStateLimitedRead: {
            [self loadMapForLimitedRead];
        } break;
            
        default:
            NSAssert1(NO, @"No typeMap", nil);
            break;
    }
}

- (void)loadMapForLimitedRead {
    self.isDraggablePin = NO;
    
    PAMPartyCore *party = [self.arrayWithParties lastObject];
    NSArray* coordinate = [party.longitude componentsSeparatedByString:@";"];
    if([coordinate count] == 2) {
        CLLocationCoordinate2D partyCoordinate = CLLocationCoordinate2DMake([coordinate[0] floatValue], [coordinate[1] floatValue]);
        NSString *nameParty = party.name.length ? party.name : NSLocalizedStringFromTable(@"NAME_PARTY_MAP", @"Language", nil);
        PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:partyCoordinate andTitle:nameParty];
        annotation.partyId = (NSInteger)party.partyId;
        [annotation setAddressToSubtitle];
        [self.mapView addAnnotation:annotation];
    }
}


- (void)loadMapForRead {
    self.isDraggablePin = NO;
    
    UIBarButtonItem *resetItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"RESET", @"Language", nil)
                                                                  style:UIBarButtonItemStylePlain target:self action:@selector(actionShowMyParty:)];
    self.navigationItem.rightBarButtonItem = resetItem;
    
    [self addAnotationsFromArrayWithParties];
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


#pragma mark - Helpers
- (void)addAnotationsFromArrayWithParties {
    NSMutableArray *arrayWithAnnotation = [NSMutableArray new];
    for (PAMPartyCore *party in self.arrayWithParties) {
        NSString *coordinateString = party.longitude;
        if(coordinateString.length) {
            NSArray* coordinate = [coordinateString componentsSeparatedByString:@";"];
            if([coordinate count] == 2) {
                CLLocationCoordinate2D partyCoordinate = CLLocationCoordinate2DMake([coordinate[0] floatValue], [coordinate[1] floatValue]);
                NSString *nameParty = party.name.length ? party.name : NSLocalizedStringFromTable(@"NAME_PARTY_MAP", @"Language", nil);
                PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:partyCoordinate andTitle:nameParty];
                annotation.partyType = (NSInteger)party.partyType;
                annotation.partyId = (NSInteger)party.partyId;
                [annotation setAddressToSubtitle];
                [arrayWithAnnotation addObject: annotation];
            }
        }
    }
    [self.mapView addAnnotations:arrayWithAnnotation];
}

- (void)addAnnotationWith:(CLLocationCoordinate2D) coordinate {
    self.trashPartyPinItem.enabled = YES;
    NSInteger partyType = [[self.partyInfo objectForKey:@"type"] integerValue];
    NSString *nameParty = [[self.partyInfo objectForKey:@"name"] length] ? [self.partyInfo objectForKey:@"name"] : NSLocalizedStringFromTable(@"NAME_PARTY_MAP", @"Language", nil);
    PAMMapAnnotation * annotation = [[PAMMapAnnotation alloc] initWithCoordinate:coordinate andTitle:nameParty];
    annotation.partyType = partyType;
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

- (PAMPartyCore *) partyByCurrentAnnotation{
    for (PAMPartyCore *party in self.arrayWithParties) {
        if(party.partyId == self.currentAnnotation.partyId) {
            return party;
        }
    }
    return nil;
}

- (void) removeAllPins {
    if(self.mapView.annotations.count >= 1) {
        id userLocation = [self.mapView userLocation];
        NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
        if ( userLocation != nil ) {
            [pins removeObject:userLocation];
        }
        [self.mapView removeAnnotations:pins];
    }
}

#pragma mark - Action
- (void)actionShowMyParty:(UIBarButtonItem *)sender {
    sender.enabled = NO;
    [self removeAllPins];
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    NSManagedObjectContext *context = [[PAMDataStore standartDataStore] mainContext];
    [self.navigationItem setTitle:[@"My parties" uppercaseString]];
    self.arrayWithParties = [PAMPartyCore fetchPartiesByUserId:userId context:context];
    [self addAnotationsFromArrayWithParties];
    [self zoomAnnotationOnMap];
}

- (void)actionTrashPartyPin:(UIBarButtonItem *)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionMapCoordinate:nameLocation:)]) {
        [self.delegate performSelector:@selector(actionMapCoordinate:nameLocation:) withObject:@"" withObject:@""];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCalloutAdd {
    if(self.typeMap == PAMMapStateWrite) {
    NSString *locationString = [NSString stringWithFormat:@"%f;%f", self.currentAnnotation.coordinate.latitude, self.currentAnnotation.coordinate.longitude];
    if(self.delegate && [self.delegate respondsToSelector:@selector(actionMapCoordinate:nameLocation:)]) {
            [self.delegate performSelector:@selector(actionMapCoordinate:nameLocation:) withObject:locationString withObject:self.currentAnnotation.subtitle];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionCalloutInfo {
    if (self.typeMap == PAMMapStateRead) {
        PAMShowPartyViewController *showView = [self.storyboard instantiateViewControllerWithIdentifier:@"PAMShowLimitedParty"];

        showView.party = [self partyByCurrentAnnotation];
        [self.navigationController pushViewController:showView animated:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (IBAction)mapLongPress:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self removeAllPins];
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
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            PAMMapAnnotation *customAnnotation = (PAMMapAnnotation *)annotation;
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"PartyLogo_Small_%ld", (long)customAnnotation.partyType]];
            [pinView setLeftCalloutAccessoryView:imageView];
            UIButton *rightButton;
            switch (self.typeMap) {
                case PAMMapStateRead: {
                    rightButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
                    [rightButton addTarget:nil action:@selector(actionCalloutInfo) forControlEvents:UIControlEventTouchUpInside];
                    pinView.rightCalloutAccessoryView = rightButton;
                } break;
                case PAMMapStateWrite: {
                    rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
                    [rightButton addTarget:nil action:@selector(actionCalloutAdd) forControlEvents:UIControlEventTouchUpInside];
                    pinView.rightCalloutAccessoryView = rightButton;
                } break;
                default: break;
            }
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
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    PAMMapAnnotation *customAnnotation = (PAMMapAnnotation *)view.annotation;
    self.currentAnnotation = customAnnotation;
}


@end
