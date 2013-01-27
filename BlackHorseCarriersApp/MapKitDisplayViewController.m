//
//  MapKitDisplayViewController.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 8/15/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "MapKitDisplayViewController.h"

#import "MapKitDisplayViewController.h"
#import "MapViewAnnotation.h"

@implementation MapKitDisplayViewController

@synthesize mapView;

// When the view loads
- (void)viewDidLoad
{
	// Set some coordinates for our position (Buckingham Palace!)
	CLLocationCoordinate2D location;
	location.latitude = (double) 51.501468;
	location.longitude = (double) -0.141596;
    
	// Add the annotation to our map view
	MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:@"Buckingham Palace" andCoordinate:location];
	[self.mapView addAnnotation:newAnnotation];
	//[newAnnotation release];
}

// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}

// Received memory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// If the view unloads, release the map view
- (void)viewDidUnload {
	[super viewDidUnload];
	//[mapView release];
	mapView = nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        
        return annotationView;
    }
    
    return nil;    
}

// Add new method above refreshTapped
- (void)plotCrimePositions:(NSString *)responseString {
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSDictionary * root = [responseString JSONValue];
    NSArray *data = [root objectForKey:@"data"];
    
    for (NSArray * row in data) {
        
        NSNumber * latitude = [[row objectAtIndex:21]objectAtIndex:1];
        NSNumber * longitude = [[row objectAtIndex:21]objectAtIndex:2];
        NSString * crimeDescription =[row objectAtIndex:17];
        NSString * address = [row objectAtIndex:13];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MyLocation *annotation = [[MyLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
        [_mapView addAnnotation:annotation];
    }
}


// Deallocations

@end
