//
//  MyLocation.h
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 9/10/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TerminalAnnotation : NSObject <MKAnnotation> {
    
}

@property (copy) NSString *name;
@property (copy) NSString *street;
@property (copy) NSString *city;
@property (copy) NSString *state_zip;
@property (copy) NSString *phone;
@property (copy) NSString *managerName;
@property (copy) NSString *managerTitle;
@property (retain,nonatomic) MKMapItem *mapitem;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate phone:(NSString*)phone manager:(NSString*)mgr title:(NSString*)ttl;

@end
