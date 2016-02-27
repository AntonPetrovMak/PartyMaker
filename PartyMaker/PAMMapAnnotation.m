//
//  PAMMapAnnotation.m
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import "PAMMapAnnotation.h"

@interface PAMMapAnnotation()

@property(strong, nonatomic) CLGeocoder* geocoder;
@end


@implementation PAMMapAnnotation

- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate andTitle:(NSString *) title{
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.title = title;
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (MKAnnotationView *) annotatinView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"PAMMapAnnotation"];
    annotationView.enabled = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.image = [UIImage imageNamed:@"PartyLogo_Small_5"];
    [annotationView setLeftCalloutAccessoryView:imageView];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    return annotationView;
}

- (void) setAddressToSubtitle {
    if([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            CLPlacemark *placeMark = [placemarks firstObject];
            self.subtitle = [NSString stringWithFormat:@"%@",placeMark.name];
        }
    }];
}

//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
//    self.coordinate = newCoordinate;
//}

@end

