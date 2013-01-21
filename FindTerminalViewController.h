//
//  BHCSecondViewController.h
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 8/12/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@class TerminalDetailViewController;

@interface FindTerminalViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate>

@property (assign) boolean_t movedtozero;
@property (nonatomic, weak) CLLocation* initialLocation;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet TerminalDetailViewController *terminalDetailViewController;
@property (weak, nonatomic) MKMapItem *currentLocation;
@property (weak, nonatomic) NSMutableArray *locItems;

- (IBAction)refreshTapped:(id)sender;
+ (id)stringToNum:(id)str;

@end
