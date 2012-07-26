//
//  SerendipitorViewController.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SerendipitorViewController.h"
#import "NVPolylineAnnotation.h"
#import "NVPolylineAnnotationView.h"
#import "Reachability.h"

@interface SerendipitorViewController (PrivateMethods)

-(void)clearEndPoints;
-(void)clearLayout;
-(void)bringBackLayout;
-(CLLocationCoordinate2D) getLocationFromAddress:(NSString*) address;
-(void)addPinAt:(float)lat lon:(float)lon title:(NSString*)tit subtitle:(NSString*)subTit;
- (CLLocationCoordinate2D) getRandomLocationArround:(CLLocationCoordinate2D)location maxDistance:(CLLocationDistance)meters;
-(void)locationButtonPressed:(id)sender;
-(void)showInfoView;
-(void)hideInfoView;
-(void)routeModeView;
-(void)readStartAndEnd;
-(void)calculateRoute:(NSString *)callbackSelectorName;
-(void)stepForward;
-(void)stepBackward;
-(void)addRandomWaypoint;
-(void)addRandomWaypoints:(NSInteger) number;
-(void)resetWaypointButtons;
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded;
-(void)focusArround:(CLLocationCoordinate2D)location;
-(void)focusArround:(CLLocationCoordinate2D)location zoom:(CLLocationDistance)meters;
-(CLLocationDistance)getDistanceFrom:(CLLocationCoordinate2D)pointA to:(CLLocationCoordinate2D)pointB;
-(void)addPins;
-(CLLocationCoordinate2D)getMidpointBetween:(CLLocationCoordinate2D)pointA and:(CLLocationCoordinate2D)pointB;
-(void)showSmallLoadingAnimation;
-(void)showBigLoadingAnimation;
-(void)stopSmallLoadingAnimation;
-(void)stopBigLoadingAnimation;
-(void)blockAndLoad;
-(void)unblockAndStopLoading;
-(NSString *)metersToHumanReadable:(NSNumber *)meters;
-(NSString *)secondsToHumanReadable:(NSInteger) num_seconds;
-(void)changeBottomBarTitle:(NSString *)text;
-(void)sendEmailTo:(NSString *)to withSubject:(NSString *) subject withBody:(NSString *)body;
-(void)emailRoute;
-(void)showPhotoButton;
-(void)hidePhotoButton;
-(UIToolbar *)bottomControls;
-(void)setBottomControls:(UIView *)v;
-(void)showBottomControls;
-(void)hideBottomControls;
-(BOOL)checkInternet;
@end


@implementation SerendipitorViewController
@synthesize mapView, start, end, directionsInterface, leftButton, rightButton, minusButton, plusButton, infoView, route, bottomBar, currentLeg, currentStep, instructionSet, waypoints, currentPolyLine, finalRoute, locationManager, photoButton;

@synthesize routeLoading; //JanM


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		isFirstLocationAvailable = NO;
    }
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
	[super loadView];
	
	isFirstLocationAvailable = NO;
}*/




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.locationManager = [[[CLLocationManager alloc] init] autorelease];
	self.locationManager.delegate = self;
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
	[[self locationManager] startUpdatingLocation];
	
	[self.directionsInterface setHidden:YES];
	
	self.start.text = @"Current Location";
	self.start.textColor = [UIColor blueColor];
	
	//Create start label
	UILabel * startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
	[startLabel setText:@"Start:"];
	[startLabel setBackgroundColor:[UIColor clearColor]];
	
	startLabel.font = [UIFont systemFontOfSize:11.0];
	startLabel.textColor =[UIColor grayColor];
	
	self.start.leftView = startLabel;
	self.start.leftViewMode = UITextFieldViewModeAlways;
	
	[startLabel release];
	
	self.end.text = @"Random Location";
	self.end.textColor = [UIColor blueColor];
	
	//Create end label
	UILabel * endLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 24)];
	[endLabel setText:@"End:"];
	[endLabel setBackgroundColor:[UIColor clearColor]];
	
	endLabel.font = [UIFont systemFontOfSize:11.0];
	endLabel.textColor =[UIColor grayColor];
	
	self.end.leftView = endLabel;
	self.end.leftViewMode = UITextFieldViewModeAlways;
	
	[endLabel release];
	
	
	
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSString *imagePath = [path stringByAppendingString:@"/gradient.png"];	
	
	
	[directionsInterface setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imagePath]]];
	
	self.instructionSet = [[[InstructionSet alloc] initWithContentsOfFile:@"Instructions.csv"] autorelease];
	
	self.finalRoute = [[[FinalRouteDelegate alloc] initForView:self] autorelease];
	
	self.waypoints = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

	[self.bottomBar setHidden:YES];
	
	//Alert for internet connection
	if([self checkInternet] == 0) 
	{ 
		NSLog(@"No Internet");
		NSString *AlertText = @"Your device has no Internet connection.";
		
		UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:AlertText message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		
		[theAlert show]; 
		[theAlert release];
	}
	
	[self blockAndLoad];
}
	   
#pragma mark -
#pragma mark internet connection check
	   
-(BOOL)checkInternet{
	//Test for Internet Connection
	Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com"];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

#pragma mark -
#pragma mark infoView functions

-(void)showInfoViewWithHTML:(NSString*)html
{	
	[self showSmallLoadingAnimation];
	if (currentHTML) {
		[currentHTML release];
	}
	currentHTML = html;
	[currentHTML retain];
	
	NSString *cssLink = @"<style>body {-webkit-user-select:none;}</style> <link href=\"style.css\" type=\"text/css\" rel=\"stylesheet\" />";
	NSString *head = [NSString stringWithFormat:@"<head><meta name=\"viewport\" content=\"user-scalable=no, width=device-width\" />%@</head>", cssLink];
	NSString *body = [NSString stringWithFormat:@"<body><div id=\"bodyText\">%@</div></body>", html];
	NSString *fullHTML = [NSString stringWithFormat:@"<html lang=\"en\">%@ %@</html>", head, body];
	
	if (!self.infoView) {
		UIWebView *newView = [[UIWebView alloc] initWithFrame:directionsInterface.frame];
		self.infoView = newView;
		[newView release];
		self.infoView.delegate = self;
		
		//NSString *path = [[NSBundle mainBundle] bundlePath];
		//NSString *imagePath = [path stringByAppendingString:@"/gradient.png"];
		
		//[self.infoView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imagePath]]];
		
		[self.infoView setBackgroundColor:[UIColor colorWithRed:0.427 green:0.517 blue:0.635 alpha:0.8]];
		[self.infoView setAlpha:0.9];
		[self.infoView setOpaque:NO];
		[self.infoView setUserInteractionEnabled:NO];
		[self.view insertSubview:self.infoView belowSubview:self.routeLoading]; 
	}

	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
	
	[infoView loadHTMLString:fullHTML baseURL:baseURL];
	
	[self showInfoView];
}

-(void)showInfoView
{
	[self.infoView setHidden:NO];
}

-(void)hideInfoView
{
	[self.infoView setHidden:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('bodyText').offsetHeight;"];
    NSLog(@"WebView height: %@", output);
	self.infoView.frame = CGRectMake(self.infoView.frame.origin.x, self.infoView.frame.origin.y, self.infoView.frame.size.width, [output intValue]+15) ;
	[self stopSmallLoadingAnimation];
}


#pragma mark -
#pragma mark mapView delegate

//ONLY AVAILABLE IN iOS 4.0
/*
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{	
	
	NSDate* eventDate = userLocation.location.timestamp;
	NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	
	if(!isFirstLocationAvailable && eventDate && abs(howRecent) < 3.0)
	{
		isFirstLocationAvailable = YES;
		[self unblockAndStopLoading];
		[self focusArround:userLocation.location.coordinate];
	}
}
*/

//Backwards compatibility
- (void)locationManager: (CLLocationManager *)manager didUpdateToLocation: (CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSDate* eventDate = newLocation.timestamp;
	NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	
	if(!isFirstLocationAvailable && eventDate && abs(howRecent) < 3.0)
	{
		isFirstLocationAvailable = YES;
		[self unblockAndStopLoading];
		[self.directionsInterface setHidden:NO];
		[self.end becomeFirstResponder];
		
		//make the map smaller to show the google branding
		CGRect currentFrame = self.mapView.frame;
		self.mapView.frame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, currentFrame.size.height - self.bottomBar.frame.size.height);
		
		CLLocationCoordinate2D fakeCenter;
		fakeCenter.latitude = newLocation.coordinate.latitude - 0.0008f;
		fakeCenter.longitude = newLocation.coordinate.longitude;
		[self focusArround:fakeCenter];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	MKPinAnnotationView *v=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"serendipitorPin"] autorelease];
	
	if ([annotation isKindOfClass:[NVPolylineAnnotation class]]) {
		return [[[NVPolylineAnnotationView alloc] initWithAnnotation:annotation mapView:self.mapView] autorelease];
	}
	
	if([annotation.title isEqualToString:@"Start"])
	{
		[v setPinColor:MKPinAnnotationColorGreen];		
	}
	else if([annotation.title isEqualToString:@"End"])
	{
		[v setPinColor:MKPinAnnotationColorRed];
	}
	else {
		return nil;
	}

	
	return v;
	
}


#pragma mark -
#pragma mark actions

-(void)barButtonPressed:(id)sender
{
	[self showSmallLoadingAnimation];
	if (sender == self.leftButton) {
		if ([self.leftButton.title isEqualToString:@"Clear"]) {
			[self clearEndPoints];
		}
		else if ([self.leftButton.title isEqualToString:@"New"])
		{
			self.start.text = @"Current Location";
			self.start.textColor = [UIColor blueColor];
			
			self.end.text = @"Random Location";
			self.end.textColor = [UIColor blueColor];
			
			[self bringBackLayout];
		}
	}
	else if(sender == self.rightButton)
	{
		if ([self.rightButton.title isEqualToString:@"Start"]) {
			[self.rightButton setTitle:@"Next"];
			[self.bottomBar setHidden:YES];
			[self showBottomControls];
			[self showPhotoButton];
			currentLeg = [NSNumber numberWithInt:0];
			currentStep = [NSNumber numberWithInt:-1];
			[self stepForward];
		
		}else if ([self.rightButton.title isEqualToString:@"Next"]) {
			[self.finalRoute addStepWithLocation:mapView.userLocation.location.coordinate instruction:currentHTML];
			
			startLocation = mapView.userLocation.location.coordinate;

//Switch if's here to recalculate the route all the times vs. calculate only when deviation > than 150m
//			if ([self.currentLeg intValue] == [self.route.legs count]-1 && [self.currentStep intValue] == [[[self.route.legs objectAtIndex:self.currentLeg] valueForKey:@"steps"] count]-1) 
//			{
			if (([self getDistanceFrom:[[[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] objectAtIndex:[currentStep intValue]] end_location] to:mapView.userLocation.location.coordinate] > 150) 
				|| [currentLeg intValue] != [route.legs count]-1 
				&& [currentStep intValue] != [[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] count])
			{
				[self addRandomWaypoints:[self.waypoints count]-1];
				[self calculateRoute:@"callbackNextButton"];
				
			} else {
				[self stepForward];
			}
			//ROUTING CHANGED [self stepForward];
			
		}else if ([self.rightButton.title isEqualToString:@"End"]) {
			[self.infoView setHidden:YES];
			[self.finalRoute addStepWithLocation:mapView.userLocation.location.coordinate instruction:currentHTML];
			
			NSString *AlertText = @"Congratulations! If you wish, you can now share your route by email.";
			
			UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:AlertText message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			
			[theAlert show]; 
			[theAlert release];
			
			[self emailRoute];
		}
		else {
			[self clearLayout];
		}
	}
	//ROUTING CHANGED [self stopSmallLoadingAnimation];
}

-(void)callbackNextButton {
	currentLeg = [NSNumber numberWithInt:0];
	currentStep = [NSNumber numberWithInt:-1];
	[self.rightButton setTitle:@"Next"];
	[self.bottomBar setHidden:YES];
	[self stepForward];
}

-(void)stepForward
{
	if(route == nil || [route.legs count] == 0 || [[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] count] == 0){
		[self showInfoViewWithHTML:@"No route found from your current location. Press 'New' to try again."];
		return;
	}
	
	currentStep = [NSNumber numberWithInt:[currentStep intValue]+1];
	
	if ([currentLeg intValue] == [route.legs count]-1 && [currentStep intValue] == [[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] count]-1) {
		
		if([currentStep intValue] <= [[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] count]-1)
		{
			NSString *html = [[[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] objectAtIndex:[currentStep intValue]] valueForKey:@"html_instructions"];
			[self showInfoViewWithHTML:html];
			[self.rightButton setTitle:@"End"];
		}
	}
	else if([currentStep intValue] <= [[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] count]-1)
	{
		NSString *html = [[[[route.legs objectAtIndex:[currentLeg intValue]] valueForKey:@"steps"] objectAtIndex:[currentStep intValue]] valueForKey:@"html_instructions"];
		NSNumber *rand = [NSNumber numberWithInt:arc4random() % [instructionSet.instructions count]];
		NSString *ins = [[instructionSet.instructions objectAtIndex:[rand intValue]] valueForKey:@"instruction"];
		
		
		html = [html  stringByReplacingOccurrencesOfString:@"<div style=\"font-size:0.9em\">Destination will be on the right</div>" withString:@""];
		html = [html  stringByReplacingOccurrencesOfString:@"<div style=\"font-size:0.9em\">Destination will be on the left</div>" withString:@""];
		
		html = [NSString stringWithFormat:@"%@ and then %@", html, ins];
		
		[self showInfoViewWithHTML:html];
	}
	else if([currentLeg intValue] < [route.legs count]-1)
	{
		currentLeg = [NSNumber numberWithInt:[currentLeg intValue]+1];
		currentStep = [NSNumber numberWithInt:0];
		[self stepForward];
	}
	else {
		[self.rightButton setTitle:@"End"];
	}
	
	[self focusArround:mapView.userLocation.location.coordinate];
}

-(CLLocationDistance)getDistanceFrom:(CLLocationCoordinate2D)pointA to:(CLLocationCoordinate2D)pointB
{
	CLLocation *locationA = [[CLLocation alloc] initWithLatitude:pointA.latitude longitude:pointA.longitude];
	CLLocation *locationB = [[CLLocation alloc] initWithLatitude:pointB.latitude longitude:pointB.longitude];
	
	CLLocationDistance dist;
	if ([locationA respondsToSelector:@selector(distanceFromLocation:)]) {
		dist = [locationA distanceFromLocation:locationB];
	} else {
		dist = [locationA getDistanceFrom:locationB];
	}
	
	[locationA release];
	[locationB release];
	
	return dist;
}

-(void)stepBackward
{
}

-(void)routeModeView
{
	//ROUTING CHANGED[self showSmallLoadingAnimation];
	[[self.rightButton valueForKey:@"view"] setHidden:NO];
	[self.rightButton setTitle:@"Start"];
	[self.bottomBar setHidden:NO];
	
	[self changeBottomBarTitle:[NSString stringWithFormat:@"%@, %@", [self metersToHumanReadable:[self.route fullDistance]], [self secondsToHumanReadable:[[self.route fullDuration] intValue]]]];
	//[self stopSmallLoadingAnimation];
}

-(void)switchEndPoints:(id)sender
{
	NSString *startText = self.start.text;
	self.start.text = self.end.text;
	self.end.text = startText;
	[self textFieldDidEndEditing:start];
	[self textFieldDidEndEditing:end];
}

-(void)plusButtonPressed:(id)sender
{
	//ROUTING CHANGED[self showSmallLoadingAnimation];
	[self hideInfoView];

	[self addRandomWaypoints:[self.waypoints count]+1];
	
	[self calculateRoute:nil];
	//ROUTING CHANGED[self stopSmallLoadingAnimation];
}

-(void)minusButtonPressed:(id)sender
{
	//ROUTING CHANGED[self showSmallLoadingAnimation];
	[self hideInfoView];
	
	[self addRandomWaypoints:[self.waypoints count]-1];
	
	[self calculateRoute:nil];
	//ROUTING CHANGED[self stopSmallLoadingAnimation];
}

-(void)submitButtonPressed:(id)sender
{
	//ROUTING CHANGED[self showSmallLoadingAnimation];
	[self clearLayout];
	[self.waypoints removeObjectsInArray:self.waypoints];
	[self resetWaypointButtons];
	[self readStartAndEnd];
	[self calculateRoute:@"callbackSubmitButtonPressed"];

	/*ROUTING CHANGED
	if ((startLocation.latitude != 0.0 || startLocation.longitude != 0.0) && (endLocation.latitude != 0.0 || endLocation.longitude != 0.0)) {
		CLLocationCoordinate2D mid = [self getMidpointBetween:startLocation and:endLocation];
		[self focusArround:mid zoom:[self getDistanceFrom:startLocation to:endLocation] + 50.0f];
	}
	else {
		[self focusArround:mapView.userLocation.location.coordinate];
	}
	[self stopSmallLoadingAnimation];
	 */
}
-(void)callbackSubmitButtonPressed {
	if ((startLocation.latitude != 0.0 || startLocation.longitude != 0.0) && (endLocation.latitude != 0.0 || endLocation.longitude != 0.0)) {
		CLLocationCoordinate2D mid = [self getMidpointBetween:startLocation and:endLocation];
		[self focusArround:mid zoom:[self getDistanceFrom:startLocation to:endLocation] + 50.0f];
	}
	else {
		[self focusArround:mapView.userLocation.location.coordinate];
	}
}
-(void)locationButtonPressed:(id)sender
{
	[self focusArround:mapView.userLocation.location.coordinate];
}

#define ALERT_DIALOG_PLEASE_CONFIRM @"Please confirm"

- (void)doneButtonPressed:(id)sender {
	UIAlertView	*confirmDoneAlert = [[[UIAlertView alloc] initWithTitle:ALERT_DIALOG_PLEASE_CONFIRM message:@"Are you sure you want to end here?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease];
	[confirmDoneAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
        //figure out which alert dialog is calling this message
    
    if ([alertView.title isEqualToString:ALERT_DIALOG_PLEASE_CONFIRM]) {
        //confirm done    
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self.infoView setHidden:YES];
            [self.finalRoute addStepWithLocation:mapView.userLocation.location.coordinate instruction:currentHTML];
            [self emailRoute];
        }
	}
}



-(void)clearLayout
{
	if([self.start isFirstResponder])
	{
		[self.start resignFirstResponder];
	}
	else if([self.end isFirstResponder])
	{
		[self.end resignFirstResponder];
	}
	[directionsInterface setHidden:YES];
	[self hideBottomControls];
	
	[[self.rightButton valueForKey:@"view"] setHidden:YES];
	self.leftButton.title = @"New";
	
	if (self.route) {
		[self routeModeView];
	}
}
			
-(void)clearEndPoints
{
	self.start.text = @"";
	self.end.text = @"";
}
				  
-(void)bringBackLayout
{
	[directionsInterface setHidden:NO];
	[self hideInfoView];
	
	[[self.rightButton valueForKey:@"view"] setHidden:NO];
	[self.leftButton setTitle:@"Clear"];
	[self.rightButton setTitle:@"Cancel"];
	[self.end becomeFirstResponder];
}
-(void)showDirectionsDialog {
	self.start.text = @"Current Location";
	self.start.textColor = [UIColor blueColor];
	
	self.end.text = @"Random Location";
	self.end.textColor = [UIColor blueColor];
	
	[self bringBackLayout];
}
-(void)showPhotoButton
{
	if(!self.photoButton)
	{
		/*JanM: should be a UIBarButtonItem 
		 self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
		 UIImage *img = [UIImage imageNamed:@"camera.png"];
		 [self.photoButton setImage:img forState:UIControlStateNormal];
		 
		 CGRect screen = self.bottomControls.frame;
		 
		 self.photoButton.frame = CGRectMake(screen.size.width - 40, screen.size.height - 40, img.size.width, img.size.height);
		 [self.photoButton setShowsTouchWhenHighlighted:YES];
		 [self.photoButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];		
		 [self.bottomControls addSubview:self.photoButton];
		 */
		self.photoButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)] autorelease];
		self.photoButton.style = UIBarButtonItemStyleBordered;
		NSRange range;
		range.location = 0;
		range.length = self.bottomControls.items.count - 1;
		NSArray *oldItems = [self.bottomControls.items subarrayWithRange:range];
		self.bottomControls.items = [oldItems arrayByAddingObject:self.photoButton];
	}
	//ToDo? [self.photoButton setHidden:NO];
	[self showBottomControls];
}

-(void)hidePhotoButton
{
	if(self.photoButton)
	{
		//ToDo?: [self.photoButton setHidden:YES];
	}
}

-(void)showBottomControls
{
	[self.bottomControls setHidden:NO];
}

-(void)hideBottomControls
{
	[self.bottomControls setHidden:YES];
}

-(UIToolbar *) bottomControls {
	if (!bottomControls) {
		CGRect screen = self.view.frame;
		bottomControls = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screen.size.height - 45, screen.size.width, 45)];
		bottomControls.tintColor = [UIColor colorWithRed:0.427 green:0.517 blue:0.635 alpha:1];
		
		//UIBarButtonItem	*locationButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(locationButtonPressed:)] autorelease];
		UIBarButtonItem *locationButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"center_on_location.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(locationButtonPressed:)] autorelease];
		locationButton.width = 30.;
		UIBarButtonItem	*doneButton = [[[UIBarButtonItem alloc] initWithTitle:@"I'm done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)] autorelease];
		UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
		UIBarButtonItem *fixedSpace40 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
		fixedSpace40.width = 40.;
		UIBarButtonItem *fixedSpace10 = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
		fixedSpace10.width = 10.;
		
		NSArray *barItems = [NSArray arrayWithObjects:locationButton, fixedSpace10, flexibleSpace, doneButton, flexibleSpace, fixedSpace40, nil];
		bottomControls.items = barItems;
		
		[self.view insertSubview:bottomControls belowSubview:routeLoading];

		
		/*
		CGRect screen = self.view.frame;
		bottomControls = [[UIView alloc] initWithFrame:CGRectMake(0, screen.size.height - 45, screen.size.width, 45)];
		
		//Set the background
		//[bottomControls setBackgroundColor:[UIColor colorWithRed:0.427 green:0.427 blue:0.427 alpha:0.7]];
		//[bottomControls setBackgroundColor:[UIColor colorWithRed:0.427 green:0.517 blue:0.635 alpha:0.4]];
		
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *imagePath = [path stringByAppendingString:@"/gradient2.png"];
		[bottomControls setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:imagePath]]];
		
		//Create the location button
		UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *img = [UIImage imageNamed:@"location.png"];
		[locationButton setImage:img forState:UIControlStateNormal];
		
		screen = bottomControls.frame;
		
		locationButton.frame = CGRectMake( 5, screen.size.height - 40, img.size.width, img.size.height);
		[locationButton setShowsTouchWhenHighlighted:YES];
		[locationButton addTarget:self action:@selector(locationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];		
		[bottomControls addSubview:locationButton];
		
		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[doneButton setTitle:@"I'm done" forState:UIControlStateNormal];
		doneButton.frame = CGRectMake((bottomControls.frame.size.width / 2.) - 40, 10, 80., 30.);
		[doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[bottomControls addSubview:doneButton];
		
		[self.view addSubview:bottomControls];
		 */
	}
	
	return bottomControls;
}

-(void)setBottomControls:(UIToolbar *)v
{
	if (v != bottomControls) {
		[v retain];
		[bottomControls release];
		bottomControls = v;
	}
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	textField.textColor = [UIColor blackColor];
	if([textField.text isEqualToString:@"Current Location"] || [textField.text isEqualToString:@"Random Location"])
	{
		//textField.text = @"";
	}
	
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if([textField.text isEqualToString:@"Current Location"] || [textField.text isEqualToString:@"Random Location"])
	{
		textField.textColor = [UIColor blueColor];
	}
	else {
		textField.textColor = [UIColor blackColor];
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	//ROUTING CHANGED[self showSmallLoadingAnimation];
	[self clearLayout];
	[self.waypoints removeObjectsInArray:self.waypoints];
	[self resetWaypointButtons];
	[self readStartAndEnd];
	
	[self calculateRoute:@"callbackSubmitButtonPressed"];
	
	/* ROUTING CHANGED
	if ((startLocation.latitude != 0.0 || startLocation.longitude != 0.0) && (endLocation.latitude != 0.0 || endLocation.longitude != 0.0)) {
		CLLocationCoordinate2D mid = [self getMidpointBetween:startLocation and:endLocation];
		[self focusArround:mid zoom:[self getDistanceFrom:startLocation to:endLocation] + 50.0f];
	}
	else {
		[self focusArround:mapView.userLocation.location.coordinate];
	}

	[self stopSmallLoadingAnimation];
	 */
    return YES;
}


- (void) readStartAndEnd
{	
	[self.finalRoute cleanFinalSteps];
	//Get start coordinates
	if ([self.start.text isEqualToString:@"Current Location"])
	{
		startLocation = mapView.userLocation.location.coordinate;
	}
	else if([self.start.text isEqualToString:@"Random Location"])
	{
		startLocation = [self getRandomLocationArround:mapView.userLocation.location.coordinate maxDistance:1000.0f];
	}
	else
	{
		startLocation = [self getLocationFromAddress:self.start.text];
	}
	
	//Get end coordinates
	if ([self.end.text isEqualToString:@"Current Location"])
	{
		endLocation = mapView.userLocation.location.coordinate;
	}
	else if([self.end.text isEqualToString:@"Random Location"])
	{
		endLocation = [self getRandomLocationArround:mapView.userLocation.location.coordinate maxDistance:1000.0f];
	}
	else
	{
		endLocation = [self getLocationFromAddress:self.end.text];
	}
}

-(void) addPins
{
	//Clean up if necessary
	if ([mapView.annotations count] > 0) {
		[mapView removeAnnotations:mapView.annotations];
	}
	
	//Add the pins
	if (startLocation.latitude != 0.0 || startLocation.longitude != 0.0) {
		[self addPinAt:startLocation.latitude lon:startLocation.longitude title:@"Start" subtitle:@""];
	}
	
	if (endLocation.latitude != 0.0 || endLocation.longitude != 0.0) {	
		[self addPinAt:endLocation.latitude lon:endLocation.longitude title:@"End" subtitle:@""];
	}
}


#pragma mark -
#pragma mark Loading functions


-(void)showSmallLoadingAnimation
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(void)showBigLoadingAnimation
{
	UIActivityIndicatorView  *av = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
	NSInteger positionX = self.view.frame.size.width / 2 -12;
	NSInteger positionY = self.view.frame.size.height / 2 -12;
	av.frame=CGRectMake(positionX, positionY, 25, 25);
	av.tag  = 1;
	[self.view addSubview:av];
	[av startAnimating];
}

-(void)stopSmallLoadingAnimation
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)stopBigLoadingAnimation
{
	UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.view viewWithTag:1];
	[tmpimg removeFromSuperview];
}

-(void)blockAndLoad
{
	[self.view setUserInteractionEnabled:NO];
	[self showSmallLoadingAnimation];
	[self showBigLoadingAnimation];
}

-(void)unblockAndStopLoading
{
	[self.view setUserInteractionEnabled:YES];
	[self stopBigLoadingAnimation];
	[self stopSmallLoadingAnimation];
}

#pragma mark -
#pragma mark geo functions

-(void)calculateRoute:(NSString *)callbackSelectorName
{
	if (self.route) {
		self.route = nil;
	}
	NSLog(@"CALL calculateRoute with callback %@", callbackSelectorName);
	//JanM overhaul of the spinner and threading
	//1. block user input with overlay
	self.routeLoading.hidden = NO;
	[self showSmallLoadingAnimation];
	//2.call the create route
	[self performSelectorInBackground:@selector(createRoute:) withObject:callbackSelectorName];
	
	//3.the createRoute will call callbackCalculateRoute to continue the program flow 
	
	/*
	//JanM start the loadingSpinner because the Route init makes a synchronous URL loading call
	//self.routeLoading.hidden = NO;
	if ([self.waypoints count] == 0) {
		Route *newRoute = [[Route alloc] initWithStart:startLocation end:endLocation];
		self.route = newRoute;
		[newRoute release];
	}
	else
	{
		Route *newRoute = [[Route alloc] initWithStart:startLocation end:endLocation waypoints:self.waypoints];
		self.route = newRoute;
		[newRoute release];
	}
	//JanM: stop spinning
	//self.routeLoading.hidden = YES;
	
	if (self.route == nil || [self.route.status isEqualToString:@"ZERO_RESULTS"]) {
		NSLog(@"ERROR: DIDN'T FIND A ROUTE");
		[self showInfoViewWithHTML:[NSString stringWithFormat:@"No route found"]];
		[self addPins];
	}
	else {
		NSLog(@"FOUND A ROUTE");
		[self routeModeView];
		self.currentPolyLine = [self decodePolyLine:route.polyLine];
		
		
		//DRAW ROUTE
		[self addPins];
		
		NVPolylineAnnotation * polyAnotation = [[NVPolylineAnnotation alloc] initWithPoints:self.currentPolyLine mapView:self.mapView];
		[self.mapView addAnnotation:polyAnotation];
		[polyAnotation release];
	}
	 */
}


// this will run on the background thread
- (void)createRoute:(NSString *)callbackSelectorName {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"CALL createRoute with selector %@", callbackSelectorName);
	if ([self.waypoints count] == 0) {
		Route *newRoute = [[Route alloc] initWithStart:startLocation end:endLocation];
		self.route = newRoute;
		[newRoute release];
	}
	else
	{
		Route *newRoute = [[Route alloc] initWithStart:startLocation end:endLocation waypoints:self.waypoints];
		self.route = newRoute;
		[newRoute release];
	}
	[self performSelectorOnMainThread:@selector(callbackCreateRoute:) withObject:callbackSelectorName waitUntilDone:NO];
	[pool release];
}

// this will run on the foreground thread again
- (void)callbackCreateRoute:(NSString *)callbackSelectorName {
	NSLog(@"CALL callbackCalculateRoute for %@", callbackSelectorName);
	
	//stop spinning
	self.routeLoading.hidden = YES;
	[self stopSmallLoadingAnimation];
	
	//continue flow
	if (self.route == nil || [self.route.status isEqualToString:@"ZERO_RESULTS"]) {
		NSLog(@"ERROR: DIDN'T FIND A ROUTE");
		[self showInfoViewWithHTML:[NSString stringWithFormat:@"No route found"]];
		[self addPins];
	}
	else {
		NSLog(@"FOUND A ROUTE");
		[self routeModeView];
		self.currentPolyLine = [self decodePolyLine:route.polyLine];
		
		//DRAW ROUTE
		[self addPins];
		
		NVPolylineAnnotation * polyAnotation = [[NVPolylineAnnotation alloc] initWithPoints:self.currentPolyLine mapView:self.mapView];
		[self.mapView addAnnotation:polyAnotation];
		[polyAnotation release];
	}
	if (callbackSelectorName) {
		SEL callbackSelector = NSSelectorFromString(callbackSelectorName);	
		[self performSelectorOnMainThread:callbackSelector withObject:nil waitUntilDone:NO];
	}
}

-(CLLocationCoordinate2D) getLocationFromAddress:(NSString*) address {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
						   [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSError *error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
		//Show error
		NSLog(@"error:address not found");
		CLLocationCoordinate2D nullLocation;
		nullLocation.latitude = 0.0;
		nullLocation.longitude = 0.0;
		
		return nullLocation;
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
	
    return location;
}

- (CLLocationCoordinate2D)getMidpointBetween:(CLLocationCoordinate2D)pointA and:(CLLocationCoordinate2D)pointB
{
	CLLocationCoordinate2D midpoint;
	midpoint.latitude = (pointA.latitude + pointB.latitude)/2;
	midpoint.longitude = (pointA.longitude + pointB.longitude)/2;
	
	return midpoint;
}


- (CLLocationCoordinate2D) getRandomLocationArround:(CLLocationCoordinate2D)location maxDistance:(CLLocationDistance)meters
{
	CLLocationCoordinate2D currentLocation = location;
	CLLocationCoordinate2D randomLocation;
	
	// get the full region arround the center
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation, meters * 2, meters * 2);
	
	// random location
	CLLocationDistance addLat = (region.span.latitudeDelta/100.0f)*((arc4random()%25)+25);
	if (arc4random()%2 == 0) {
		addLat = addLat * (-1.0f);
	}
	CLLocationDistance addLon = (region.span.longitudeDelta/100.0f)*((arc4random()%25)+25);
	if (arc4random()%2 == 0) {
		addLon = addLon * (-1.0f);
	}
	
	randomLocation.latitude=region.center.latitude + addLat;

	randomLocation.longitude=region.center.longitude + addLon;
	
	return randomLocation;
}

-(void)addRandomWaypoints:(NSInteger) number
{
	//JanM: I think this is error prone
	//[self.waypoints removeObjectsInArray:self.waypoints];
	[self.waypoints removeAllObjects];
	
	for (NSInteger i=0; i<number; i++) {
		[self addRandomWaypoint];
	}
	
	[self resetWaypointButtons];
}

-(void)addRandomWaypoint
{	
	CLLocationCoordinate2D mid = [self getMidpointBetween:startLocation and:endLocation];
	CLLocationCoordinate2D waypointCoord = [self getRandomLocationArround:mid maxDistance:[self getDistanceFrom:startLocation to:endLocation]/2.0f];
	
	CLLocation * waypoint = [[CLLocation alloc] initWithLatitude:waypointCoord.latitude longitude:waypointCoord.longitude];
	
	[self.waypoints addObject:waypoint];
	
	[waypoint release];
}

-(void) resetWaypointButtons
{
	if ([self.waypoints count] > 4) 
	{
		[self.plusButton setEnabled:NO];
	}else {
		[self.plusButton setEnabled:YES];
	}
	
	if ([self.waypoints count] < 1) 
	{
		[self.minusButton setEnabled:NO];
	}else {
		[self.minusButton setEnabled:YES];
	}
}

-(void)focusArround:(CLLocationCoordinate2D)location
{
	MKCoordinateRegion region;
	region.center=location;
	MKCoordinateSpan span;
	span.latitudeDelta=0.005f; 
	span.longitudeDelta=0.005f;
	region.span=span;
	[self.mapView setRegion:region animated:TRUE];
}

-(void)focusArround:(CLLocationCoordinate2D)location zoom:(CLLocationDistance) meters
{
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, meters, meters);

	[self.mapView setRegion:region animated:TRUE];
}

-(void)addPinAt:(float)lat lon:(float)lon title:(NSString*)title subtitle:(NSString*)subtitle {
	
	CLLocationCoordinate2D location;
	location.latitude = lat;
	location.longitude = lon;
	
	// add custom place mark
	CustomPlaceMark *placemark=[[CustomPlaceMark alloc] initWithCoordinate:location];
	placemark.title = title;
	placemark.subtitle = subtitle;
	[self.mapView addAnnotation:placemark];
	[placemark release];
}


#pragma mark -
#pragma mark memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
	//[finalRoute didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	//[directionsInterface release];
	//[infoView release];
	//[mapView release];
}


- (void)dealloc {
	[mapView release];
	[start release];
	[end release];
	[directionsInterface release];
	[infoView release];
	[bottomBar release];
	[route release];
	[waypoints release];
	[finalRoute release];
	if (bottomControls) {
		[bottomControls release];
	}
	[routeLoading release];
	//[bottomControls release];
	if (currentHTML) {
		[currentHTML release];
	}
	
    [super dealloc];
}

#pragma mark -
#pragma mark Conversions

-(NSString *) metersToHumanReadable:(NSNumber *)meters
{	
	if ([meters floatValue] >= 1000) {
		return [NSString stringWithFormat:@"%.1f Km", [meters floatValue]/1000];
	}
	else {
		return [NSString stringWithFormat:@"%d m", [meters intValue]];
	}
}

-(NSString *) secondsToHumanReadable:(NSInteger) num_seconds
{
	NSInteger days = num_seconds / (60 * 60 * 24);
	num_seconds -= days * (60 * 60 * 24);
	NSInteger hours = num_seconds / (60 * 60);
	num_seconds -= hours * (60 * 60);
	NSInteger minutes = num_seconds / 60;
	num_seconds -= minutes * 60;
	
	NSMutableString * result = [[[NSMutableString alloc] initWithString:@""] autorelease];
	
	if (days > 0) {
		if (days == 1) {
			[result appendFormat:@"%d day ", days];
		}
		else {
			[result appendFormat:@"%d days ", days];
		}
	}
	if (hours > 0) {
		if (hours == 1) {
			[result appendFormat:@"%d hour ", hours];
		}
		else {
			[result appendFormat:@"%d hours ", hours];
		}
	}
	if (minutes > 0) {
		[result appendFormat:@"%d min ", minutes];
	}
	if (num_seconds > 0 && days == 0 && hours == 0 && minutes == 0) {
		[result appendString:@"Less than 1 min"];
	}
	
	return [NSString stringWithString:result];
}

-(void)changeBottomBarTitle:(NSString *)text
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:14.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor =[UIColor whiteColor];
	label.text=text;	
	self.bottomBar.topItem.titleView = label;		
	[label release];
}


-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
		//NSLog(@"%f,%f",[latitude floatValue],[longitude floatValue]);
		[loc release];
		[latitude release];
		[longitude release];
	}
	return array;
}


#pragma mark -
#pragma mark Photo and email

-(void) takePicture:(id)sender
{
	[self.finalRoute takePhoto];
}


-(void)emailRoute
{
	[self.finalRoute sendEmail];
}


@end
