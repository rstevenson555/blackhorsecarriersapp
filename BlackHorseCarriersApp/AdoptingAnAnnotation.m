//
//  AdoptingAnAnnotation.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/23/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "AdoptingAnAnnotation.h"
@implementation AdoptingAnAnnotation
{
    
}
@synthesize latitude;
@synthesize longitude;

- (id) initWithLatitude:(CLLocationDegrees) lat longitude:(CLLocationDegrees) lng {
    latitude = lat;
    longitude = lng;
    return self;
}
- (CLLocationCoordinate2D) coordinate {
    CLLocationCoordinate2D coord = {self.latitude, self.longitude};
    return coord;
}
- (NSString *) title {
    return @"217 2nd St";
}
- (NSString *) subtitle {
    return @"San Francisco CA 94105";
}
@end