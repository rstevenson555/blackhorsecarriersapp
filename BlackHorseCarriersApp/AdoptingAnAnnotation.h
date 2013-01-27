//
//  AdoptingAnAnnotation.h
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/23/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AdoptingAnAnnotation : NSObject  <MKMapViewDelegate> {
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDegrees latitude;
@property (nonatomic, readonly) CLLocationDegrees longitude;

- (NSString *) title;
- (NSString *) subtitle;

@end