//
//  BHCSecondViewController.m
//  BlackHorseCarriersApp
//
//  Created by Robert Stevenson on 8/12/12.
//  Copyright (c) 2012 Robert Stevenson. All rights reserved.
//

#import "FindTerminalViewController.h"
#import "TerminalAnnotation.h"
#import "SBJSON.h"
#import "ASIHTTPRequest.h"
#import "TerminalDetailViewController.h"
#import "Constants.h"
#import <AddressBook/AddressBook.h>

@implementation FindTerminalViewController

@synthesize mapView, terminalDetailViewController, movedtozero, initialLocation, searchBar, locItems;

void putstr(NSString *str) {
    NSLog(@"'%@'",str);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.locItems = [NSMutableArray arrayWithCapacity:0];
    
    mapView.mapType = MKMapTypeStandard;   // also MKMapTypeSatellite or MKMapTypeHybrid or MKMapTypeStandard
    
    [self getTerminals];
    
    putstr(@"getTerminals complete");
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                 bundle:nil];
    terminalDetailViewController = [sb instantiateViewControllerWithIdentifier:@"TerminalDetailViewController"];
    
    self.currentLocation = [MKMapItem mapItemForCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    movedtozero = false;
}

- (void)viewDidUnload
{
    mapView = nil;
    //[self setSearch_bar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showDetails:(id)sender
{
    NSArray *annArray = mapView.selectedAnnotations;
    TerminalAnnotation *annotation = annArray[0];
    
    //[MKMapItem
    
    // the detail view does not want a toolbar so hide it
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController pushViewController:terminalDetailViewController animated:YES];
    
    //TerminalAnnotation *annotation = (TerminalAnnotation*)[[mapView annotations] objectAtIndex:tag];
    //NSLog(@"annotation clicked is: %@", annotation);
    // 2700 Saucon Valley Road,Center Valley,PA 18034
    
    terminalDetailViewController.findTerminalViewController = self;
    
    /* set the field labels on the terminal Detail View */
    terminalDetailViewController.locationName.text = annotation.name;
    terminalDetailViewController.locationAddress.text = annotation.street;
    terminalDetailViewController.locationCity.text = annotation.city;
    
    NSString *managerAndTitle = @"";
    managerAndTitle = [managerAndTitle stringByAppendingString:annotation.managerName];
    managerAndTitle = [managerAndTitle stringByAppendingString:@" ("];
    managerAndTitle = [managerAndTitle stringByAppendingString:annotation.managerTitle];
    managerAndTitle = [managerAndTitle stringByAppendingString:@")"];
    
    terminalDetailViewController.locationManager.text = managerAndTitle;
    terminalDetailViewController.locationPhone.text = annotation.phone;
    terminalDetailViewController.locationTitle.text = annotation.title;
    
    // city, state zip
    NSString *result = @"";
    result = [result stringByAppendingString:annotation.city];
    result = [result stringByAppendingString:@" "];
    result = [result stringByAppendingString:annotation.state_zip];
    
    /* set the city label to City + state */
    terminalDetailViewController.locationCity.text = result;
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[TerminalAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorPurple;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (IBAction) annotationViewClick:(id) sender {
    NSLog(@"clicked");
}

/*- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
 {
 self.mapView.centerCoordinate = userLocation.location.coordinate;
 }*/

// Tell MKMapView to zoom to current location when found
/*- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation
 {
 if (!movedtozero) {
 NSLog(@"didUpdateUserLocation just got called!");
 
 //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([userLocation coordinate], 250, 250);
 //[mv setRegion:region animated:YES];
 }
 movedtozero = true;
 }*/

- (void)mapView:(MKMapView *)mapv didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if ( initialLocation==NULL )
    {
        initialLocation = userLocation.location;
        
        CLLocationCoordinate2D currentCoord = userLocation.location.coordinate; // Grab user's coordinate
        MKCoordinateSpan span = {.latitudeDelta = 0.02, .longitudeDelta = 0.02}; // set range of zoom
        MKCoordinateRegion region;
        region.center = currentCoord;
        region.span = span;
        
        [mapView setRegion:region animated:YES]; // animate and center to said region
        [mapView regionThatFits:region]; // alters aspect ratio of map to fit on screen
        
    }
}

-(IBAction)openAddressInMaps:(UIButton *)sender {
    NSString *address = @"2107 S 320th St, FederalWay, WA, 98003";
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks.lastObject;
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        MKPlacemark *placeMark = [[MKPlacemark alloc]initWithCoordinate:coordinates addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:placeMark];
        mapItem.name = @"Panera Bread";
        NSDictionary *options = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        [mapItem openInMapsWithLaunchOptions:options];
    }];
}

-(MKMapItem*)createMKMapItemFromLatLng:(double)lat:(double)lng:(NSDictionary*)map_address {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat,lng);
    //NSLog(@"viewDidLoad '%@'",self.locItems);
    
    MKPlacemark* p = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:map_address];
    MKMapItem* item =  [[MKMapItem alloc] initWithPlacemark:p];
    return item;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
        
    }
}


// Add new method above refreshTapped
- (void)plotTerminalLocations:(NSString *)responseString {
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
    NSDictionary * root = [responseString JSONValue];
    
    for (NSDictionary * row in root) {
        NSNumber * latitude = [FindTerminalViewController stringToNum: row[@"lat"]];
        NSNumber * longitude = [FindTerminalViewController stringToNum: row[@"lng"]];
        NSString * displayCity = row[@"displaycity"];
        NSString * fullAddress = row[@"address"];
        NSString * phone = row[@"phone"];
        NSString * mgr = row[@"manager"];
        NSString * ttl = row[@"title"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        
        NSDictionary *address = @{
        (NSString *)kABPersonAddressStreetKey: fullAddress,
        (NSString *)kABPersonAddressCityKey: displayCity,
        (NSString *)kABPersonAddressStateKey: @"NY",
        (NSString *)kABPersonAddressZIPKey: @"10118",
        (NSString *)kABPersonAddressCountryCodeKey: @"US"
        };
        
        MKMapItem *item = [self createMKMapItemFromLatLng:coordinate.latitude :coordinate.longitude :address];
        
        //NSLog(@"in plotTerminalLocations, in loop");
        item.phoneNumber = phone;
        item.name = displayCity;
        [self.locItems addObject:item];
        
        TerminalAnnotation *annotation = [[TerminalAnnotation alloc]
                                          initWithName:displayCity
                                          address:fullAddress
                                          coordinate:coordinate
                                          phone:phone manager:mgr title:ttl];
        annotation.mapitem = item;
        
        [mapView addAnnotation:annotation];
    }
}

+ (NSString*)substring:(NSString *)inputStr
{
    NSLog(@"original: '%@'",inputStr);
    NSRange range = [inputStr rangeOfString:@"," options:NSLiteralSearch range:NSMakeRange(0, [inputStr length])];
    NSLog(@"range.location: %u", range.location);
    NSString *substring = [inputStr substringFromIndex:range.location+1];
    NSLog(@"substring: '%@'", substring);
    return substring;
}

- (IBAction)refreshTapped:(id)sender
{
    [self getTerminals];
}

- (void)getTerminals {
    // 3
    NSURL *url = [NSURL URLWithString:GET_TERMINALS_URL];
    
    // 4
    ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
    __weak ASIHTTPRequest *request = _request;
    
    request.requestMethod = @"GET";
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    //[request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 5
    request.delegate = self;
    [request setDelegate:self];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        // Add new line inside refreshTapped, in the setCompletionBlock, right after logging the response string
        [self plotTerminalLocations:responseString];
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    // 6
    [request startAsynchronous];
}

/*- (void)parseSampleJson
 {
 // 2
 NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"sampleout" ofType:@"json"];
 NSString *formatString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:nil];
 
 NSDictionary * root = [formatString JSONValue];
 
 for (NSDictionary * row in root) {
 NSNumber * latitude = [FindTerminalViewController stringToNum: [row objectForKey:@"lat"]];
 NSNumber * longitude = [FindTerminalViewController stringToNum: [row objectForKey:@"lng" ]];
 NSString * displaycity = [row objectForKey:@"displaycity"];
 NSString * address = [row objectForKey:@"address"];
 
 CLLocationCoordinate2D coordinate;
 coordinate.latitude = latitude.doubleValue;
 coordinate.longitude = longitude.doubleValue;
 TerminalAnnotation *annotation = [[TerminalAnnotation alloc] initWithName:displaycity address:address coordinate:coordinate] ;
 [mapView addAnnotation:annotation];
 
 }
 }*/

+ (id)stringToNum:(id)str {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:str];
    //[f release];
    return myNumber;
}

#pragma mark -
#pragma mark UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:theSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
        //Error checking
        
        CLPlacemark *placemark = placemarks[0];
        CLLocationCoordinate2D currentCoord = CLLocationCoordinate2DMake(placemark.region.center.latitude, placemark.region.center.longitude);
        MKCoordinateSpan span = {.latitudeDelta = 0.3, .longitudeDelta = 0.3}; // set range of zoom
        MKCoordinateRegion region;
        region.center = currentCoord;
        region.span = span;
        
        [mapView setRegion:region animated:YES]; // animate and center to said region
        [mapView regionThatFits:region]; // alters aspect ratio of map to fit on screen
        
    }];
}

/** called when you click in the search bar **/
- (void)searchBarTextDidBeginEditing:(UISearchBar *)sb
{
    sb.text = @"";
}

/* when the user clicks 'get directions' */
-(id)getDrivingDirections
{
    NSArray *annArray = mapView.selectedAnnotations;
    TerminalAnnotation *annotation = annArray[0];
    
    NSDictionary *options = @{
        MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
        MKLaunchOptionsMapTypeKey:
            [NSNumber numberWithInteger:MKMapTypeStandard],
            MKLaunchOptionsShowsTrafficKey:@YES
    };
    
    NSMutableArray *directionArray = [NSMutableArray arrayWithCapacity:0];
    [directionArray addObject:self.currentLocation];
    [directionArray addObject:annotation.mapitem];
    [MKMapItem openMapsWithItems:directionArray launchOptions:options];
    return self;
}

@end
