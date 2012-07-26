//
//  SerendipitorViewController.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKPinAnnotationView.h>
#import <CoreLocation/CoreLocation.h>
#import "CustomPlaceMark.h"
#import "Route.h"
#import "InstructionSet.h"
#import "SerendipitorMainView.h"
#import "FinalRouteDelegate.h"



@interface SerendipitorViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate, SerendipitorMainView, CLLocationManagerDelegate, UIWebViewDelegate, UIAlertViewDelegate> {
	MKMapView *mapView;
	UITextField *start;
	UITextField *end;
	UIView *directionsInterface;
	UIBarButtonItem *leftButton;
	UIBarButtonItem *rightButton;
	UIBarButtonItem *plusButton;
	UIBarButtonItem *minusButton;
	UINavigationBar *bottomBar;
	UIWebView *infoView;
	Route *route;
	NSNumber *currentLeg;
	NSNumber *currentStep;
	InstructionSet *instructionSet;
	NSMutableArray *waypoints;
	CLLocationCoordinate2D startLocation;
	CLLocationCoordinate2D endLocation;
	BOOL isFirstLocationAvailable;
	NSMutableArray *currentPolyLine;
	FinalRouteDelegate * finalRoute;
	NSString * currentHTML;
	UIBarButtonItem *photoButton;
	UIToolbar *bottomControls;
	
	//Backward compatible location
	CLLocationManager *locationManager;
	
	//JanM: added a label to indicate loading route
	UIView *routeLoading;
	//UILabel *routeLoading;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UITextField *start;
@property(nonatomic, retain) IBOutlet UITextField *end;
@property(nonatomic, retain) IBOutlet UIView *directionsInterface;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *leftButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *rightButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *plusButton;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *minusButton;
@property(nonatomic, retain) IBOutlet UINavigationBar *bottomBar;
@property(nonatomic, retain) UIBarButtonItem *photoButton;
@property(nonatomic, retain) UIWebView *infoView;
@property(nonatomic, retain) Route *route;
@property(nonatomic, retain) NSNumber *currentLeg;
@property(nonatomic, retain) NSNumber *currentStep;
@property(nonatomic, retain) InstructionSet *instructionSet;
@property(nonatomic, retain) NSMutableArray *waypoints;
@property(nonatomic, retain) NSMutableArray *currentPolyLine;
@property(nonatomic, retain) FinalRouteDelegate * finalRoute;

@property (nonatomic, retain) CLLocationManager *locationManager;

@property(nonatomic, retain) IBOutlet UIView *routeLoading;


-(IBAction)switchEndPoints:(id)sender;
-(IBAction)barButtonPressed:(id)sender;
-(IBAction)submitButtonPressed:(id)sender;
-(IBAction)plusButtonPressed:(id)sender;
-(IBAction)minusButtonPressed:(id)sender;
-(IBAction)takePicture:(id)sender;

-(void)showInfoViewWithHTML:(NSString*)html;

@end

