//
//  PAMMapAnnotation.m
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMMapAnnotation.h"

@implementation PAMMapAnnotation

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
    }
    return self;
}

- (MKAnnotationView *) annotatinView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"PAMMapAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"PartyLogo_Small_5"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    return annotationView;
}

@end

