//
//  FinalRouteDelegate.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "SerendipitorMainView.h"
#import "Route.h"

@interface FinalRouteDelegate : NSObject <MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	NSMutableArray * finalSteps;
	UIViewController <SerendipitorMainView> *viewController;
	NSString * currentImage;
	BOOL canCleanUp;
}

@property (nonatomic, retain) NSMutableArray * finalSteps;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) UIViewController<SerendipitorMainView> *viewController;
@property (nonatomic, retain) NSString * currentImage;

-(FinalRouteDelegate *) initForView:(UIViewController<SerendipitorMainView> *) v;

-(void) addStepWithLocation:(CLLocationCoordinate2D)location instruction:(NSString *)instruction;

-(NSArray *) getWaypointArrayFrom:(NSMutableArray *)finalSteps;
-(NSString *) encodeWaypoints:(NSArray *)waypoints;

-(void) cleanFinalSteps;
-(void) didReceiveMemoryWarning;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;

-(void) sendEmail;
-(void) takePhoto;
-(void) displayComposerSheet;
-(CLLocation *)locationFromString:(NSString *)str;

@end
