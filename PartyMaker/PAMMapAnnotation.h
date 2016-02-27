//
//  PAMMapAnnotation.h
//  PartyMaker
//
//  Created by Petrov Anton on 23.02.16.
//  Copyright © 2016 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PAMMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) NSInteger partyId;
@property (nonatomic, assign) NSInteger partyType;


- (instancetype) initWithCoordinate:(CLLocationCoordinate2D) coordinate andTitle:(NSString *) title;
- (void) setAddressToSubtitle;
- (MKAnnotationView *) annotatinView;

@end
