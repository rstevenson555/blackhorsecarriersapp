#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapKitDisplayViewController : UIViewController <MKMapViewDelegate> {
    
//@interface MapKitDisplayViewController : UIViewController {
	MKMapView *mapView;
    
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@end