//
//  FinalRouteDelegate.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FinalRouteDelegate.h"
#import "FinalRouteStep.h"
#import "GoogleEncoder.h"
#import "NSDataBase64.h"


@implementation FinalRouteDelegate
@synthesize viewController, currentImage, finalSteps;

#pragma mark -
#pragma mark Init

-(FinalRouteDelegate *) initForView:(UIViewController<SerendipitorMainView> *) v
{
	self.viewController = v;
	self.finalSteps = [[NSMutableArray alloc] initWithCapacity:0];
	canCleanUp = YES;
	return self;
}

#pragma mark -
#pragma mark Steps

-(void) addStepWithLocation:(CLLocationCoordinate2D)location instruction:(NSString *)instruction
{	
	//JanM dirty hack to not store 0,0 steps
	//if (location.latitude == 0 || location.longitude == 0)
	//	return;
	NSString * loc = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
	
	FinalRouteStep *step = [[FinalRouteStep alloc] init];
	
	[step setLocation:loc];
	if (self.currentImage) {
		step.photo = self.currentImage;
		self.currentImage = nil;
	}
	[step setInstruction:instruction];
	[step setTimestamp:[NSDate date]];
	
	[self.finalSteps addObject:step];
	
	[step release];
}

-(NSArray *) getWaypointArrayFrom:(NSMutableArray *)finalStepsArray
{
	NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	for (FinalRouteStep *st in finalStepsArray) {
		NSArray *values = [st.location componentsSeparatedByString: @","];
		CLLocation * newLocation = [[CLLocation alloc] initWithLatitude:[[values objectAtIndex:0] floatValue] longitude:[[values objectAtIndex:1] floatValue]];
	
		[result addObject:newLocation];
		
		[newLocation release];
	}
	
	return result;
}


-(NSString *) encodeWaypoints:(NSArray *)waypoints
{
	GoogleEncoder * ge = [[[GoogleEncoder alloc] initWithLocations:waypoints] autorelease];
	
	return [ge googlePolyline];
}


#pragma mark -
#pragma mark Photo

- (void)takePhoto
{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	
	imagePicker.delegate = self; 
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else {
		[imagePicker release];
		return;
	}
	
	[self.viewController presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{			
	if (self.currentImage) {
		self.currentImage = nil; 
	}

	UIImage * small = [self scaleAndRotateImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
	
	
	NSString *imagePath = [NSString stringWithFormat:@"%@/%.0f.jpg",[self applicationDocumentsDirectory], [[NSDate date] timeIntervalSince1970]];
	NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(small, 0.8f)];
	
	if ([imageData writeToFile:imagePath atomically:YES]) {
		self.currentImage = imagePath;
	}
	
	[self.viewController dismissModalViewControllerAnimated:YES];
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
	//JanM updated this to 600
	//int kMaxResolution = 800; // Size of the bigger side of the image
	int kMaxResolution = 600;
	
	CGImageRef imgRef = image.CGImage;
	
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		}
		else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
			
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
			
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	}
	else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	
	CGContextConcatCTM(context, transform);
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	// The user canceled -- simply dismiss the image picker.
	[self.viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Email


- (void)sendEmail
{
	[self displayComposerSheet];
}

-(void)displayComposerSheet 

{
	
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	
    picker.mailComposeDelegate = self;
	
    
	
    [picker setSubject:@"My Serendipitor route"];
	
	
    // Set up recipients
	
    //NSArray *toRecipients = [NSArray arrayWithObject:@"davidjonasdesign@gmail.com"]; 
	
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"share@serendipitor.net", nil]; 
	
    //NSArray *bccRecipients = [NSArray arrayWithObject:@""]; 
	
    
	
    //[picker setToRecipients:toRecipients];
	
    [picker setCcRecipients:ccRecipients];  
	
    //[picker setBccRecipients:bccRecipients];
	
	//For encoded waypoints instead of to: options
	//NSString * geocode = [self encodeWaypoints:[self getWaypointArrayFrom:self.finalSteps]];
	
	
	//NSMutableString *emailBody = [NSMutableString stringWithFormat: @"I just walked this route using <a href=\"http://survival.sentientcity.net/serendipitor\">Serendipitor</a>!<br /><br /> <a href=\"%@\">See it on the map</a><br /><br /><a href=\"http://survival.sentientcity.net/serendipitor\">Serendipitor</a><br />survival.sentientcity.net/serendipitor<br /><span style=\"font-style:italic\">find something by looking for something else</span><br /><br /> -+-<br /><br /> These are the steps I took:",link];
	NSString *emailBody = @"";
	
	NSInteger counter = 0;
	
	for (FinalRouteStep *st in self.finalSteps) {
		counter ++;
		
		//Add instruction
		emailBody = [emailBody stringByAppendingFormat:@"%d. %@<br /><br />",counter, st.instruction];
		
		/*
		// Attach an image to the email by adding a embeded base64 img tag
		if (st.photo) {
			NSData * imageData = [[NSData alloc] initWithContentsOfFile:st.photo];
			NSString *base64String = [imageData base64EncodedString];
			[emailBody appendString:[NSString stringWithFormat:@"<p><b><img src='data:image/png;base64,%@'></b></p>",base64String]];
			[imageData release];
		}
		*/
		
		// Attach an image to the email by adding an attached image file
		if (st.photo) {
			NSData * imageData = [[NSData alloc] initWithContentsOfFile:st.photo];
			[picker addAttachmentData:imageData mimeType:@"image/jpeg" fileName:[NSString stringWithFormat:@"step_%d.jpg",counter]];
			[imageData release];
		}
	}

	NSString * start = [[self.finalSteps objectAtIndex:0] valueForKey:@"location"];
	NSString * link = [NSString stringWithFormat:@"http://maps.google.com/maps?mrsp=0&dirflg=w&q=from:%@",start];
	NSString *staticImg;// = @"<img src=\"http://maps.google.com/maps/api/staticmap?path=color:0x0000ff|weight:5|40.737102,-73.990318|40.749825,-73.987963|40.752946,-73.987384|40.755823,-73.986397&size=512x512&sensor=false\" />";
	
	NSMutableArray *waypoints = [NSMutableArray array]; //CLLocation objects
	NSUInteger i;
	NSUInteger count = [self.finalSteps count];
	if (count == 0) {
		//ToDo: abort ?
	}
	//chst=d_map_spin
	//chld=<scale_factor>|<rotation_deg>|<fill_color>|<font_size>|<font_style>|<text_line_1>|...|<text_line_n>
	//NSString *baseIconURL = @"http://chart.apis.google.com/chart%3Fchst%3Dd_map_spin%26chld%3D0.5%257C0%257CFFFF00%257C10%257C_%257C"; 
	//append the label to the end
	//NSString *markers = [NSString stringWithFormat:@"markers=icon:http://www.serendipitor.net/assets/begin.png|%@", [(FinalRouteStep *)[self.finalSteps objectAtIndex:0] location]];
	NSString *markers = [NSString stringWithFormat:@"markers=color:green|%@", [(FinalRouteStep *)[self.finalSteps objectAtIndex:0] location]];
	for (i = 1; i < count; i++) {
		FinalRouteStep *st = [self.finalSteps objectAtIndex:i];
		link = [link stringByAppendingFormat:@"+to:%@", st.location];
		//	NSString * loc = [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
		
		if (i < count - 1) {
			CLLocation *waypoint = [self locationFromString:st.location];
			if (waypoint) {
				[waypoints addObject:waypoint];
				markers = [markers stringByAppendingFormat:@"&markers=color:blue|%@", st.location];
			} else {
				NSLog(@"illegal waypoint: %@ at idx: %d", st.location, i);
			}
			//markers = [markers stringByAppendingFormat:@"&markers=icon:http://www.serendipitor.net/assets/mid.png|%@", st.location];
		} else {
			//markers = [markers stringByAppendingFormat:@"&markers=icon:http://www.serendipitor.net/assets/end.png|%@", st.location];
			markers = [markers stringByAppendingFormat:@"&markers=color:red|%@", st.location];
		}
	}
	markers = [markers stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if (count < 2) {
		//won't happen. show only the one marker on the map
		staticImg = [NSString stringWithFormat:@"<img src='http://maps.google.com/maps/api/staticmap?%@&size=600x450&sensor=false' />", markers];
	} else {
		CLLocation *startPoint = [self locationFromString:[(FinalRouteStep *)[self.finalSteps objectAtIndex:0] location]];
		CLLocation *endPoint = [self locationFromString:[(FinalRouteStep *)[self.finalSteps lastObject] location]];
		//Create a new Route with the finalSteps as waypoints
		//the Route object calls the Google Directions right away
		//TESTING
		/*
		startPoint = [[[CLLocation alloc] initWithLatitude:52.516964 longitude:13.370272] autorelease];
		endPoint = [[[CLLocation alloc] initWithLatitude:52.517115 longitude:13.390126] autorelease];
		waypoints = [NSMutableArray arrayWithObjects:
					 [[[CLLocation alloc] initWithLatitude:52.516925 longitude:13.370260] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.516926 longitude:13.370254] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.516915 longitude:13.370234] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.515858 longitude:13.368969] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.515995 longitude:13.370815] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.515664 longitude:13.371995] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.515613 longitude:13.371880] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.515606 longitude:13.371945] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.516878 longitude:13.384763] autorelease],
					 [[[CLLocation alloc] initWithLatitude:52.517115 longitude:13.390126] autorelease],
					 nil];
		 */
		NSString *paths = @"";
		while (waypoints.count > 8) {
			CLLocation *subEndPoint = (CLLocation *)[waypoints objectAtIndex:8];
			NSRange subrange;
			subrange.location = 0;
			subrange.length = 8;
			Route *subroute = [[[Route alloc] initWithStart:startPoint.coordinate end:subEndPoint.coordinate waypoints:[NSMutableArray arrayWithArray:[waypoints subarrayWithRange:subrange]]] autorelease];
			paths = [paths stringByAppendingFormat:@"path=color:0x0099CCC0|weight:5|enc:%@&", subroute.polyLine];
			startPoint = subEndPoint;
			if (waypoints.count > 9) {
				//subrange.location = 9;
				//subrange.length = waypoints.count - 9;
				subrange.length = 9;
				[waypoints removeObjectsInRange:subrange];
			} else {
				waypoints = [NSMutableArray array];
			}			
		}
		Route *finalRoute = [[[Route alloc] initWithStart:startPoint.coordinate end:endPoint.coordinate waypoints:waypoints] autorelease];
		paths = [[paths stringByAppendingFormat:@"path=color:0x0099CCC0|weight:5|enc:%@&", finalRoute.polyLine] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		staticImg = [NSString stringWithFormat:@"<img src='http://maps.google.com/maps/api/staticmap?%@&%@&size=600x450&sensor=false' />", paths, markers];
		NSLog(@"finalRoute waypoint count: %d polyline: %@ img:%@", waypoints.count, finalRoute.polyLine, staticImg);
		
	}
	
	
	emailBody = [emailBody stringByAppendingFormat:@"-+-<br /><br />Seredipitor<br /><em>find something by looking for something else</em><br /><a href=\"http://www.serendipitor.net\">http://www.serendipitor.net</a><br /><br />-+-<br /><br /><b>%@</b><br /><a href=\"%@\">See it on the map</a>", staticImg, link];
    NSLog(@"emailBody: %@", emailBody);
	//emailBody = [emailBody stringByAppendingString:@"<br /><br />-+-<br /><br /> And these are the photos I took:<br /><br />"];
   
	
	// Fill out the email body text
    [picker setMessageBody:emailBody isHTML:YES];
	
    
	
    [self.viewController presentModalViewController:picker animated:YES];
    [picker release];
}

- (CLLocation *)locationFromString:(NSString *)str {
	NSArray *arr = [str componentsSeparatedByString:@","];
	if (arr.count != 2) {
		return nil;
	}
	CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[(NSString *)[arr objectAtIndex:0] doubleValue] longitude:[(NSString *)[arr objectAtIndex:1] doubleValue]] autorelease];
	if (loc.coordinate.latitude == 0 && loc.coordinate.longitude == 0) {
		return nil;
	}
	return loc;
}
						 
						 
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    // Notifies users about errors associated with the interface
	
    switch (result)
    {			
        case MFMailComposeResultCancelled:
            [self.viewController showInfoViewWithHTML:@"Your email was cancelled."];
            break;
			
        case MFMailComposeResultSaved:
            [self.viewController showInfoViewWithHTML:@"Your email was saved."];
            break;
			
        case MFMailComposeResultSent:
            [self.viewController showInfoViewWithHTML:@"Your email was sent."];
			//[self wipeOutDB];
            break;
			
        case MFMailComposeResultFailed:
            [self.viewController showInfoViewWithHTML:@"Your email failed."];
            break;
			
        default:
            [self.viewController showInfoViewWithHTML:@"Your email was not sent."];
            break;
    }
	
    [self.viewController dismissModalViewControllerAnimated:YES];
	//Force the edit route view
	[self.viewController showDirectionsDialog];
}


#pragma mark -
#pragma mark Documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

#pragma mark -
#pragma mark Cleanup

-(void)cleanFinalSteps
{	
	self.finalSteps = nil;
	self.finalSteps = [[NSMutableArray alloc] initWithCapacity:0];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *directory = [self applicationDocumentsDirectory];
	NSError *error = nil;
	for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
		BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
		if (!success || error) {
			NSLog(@"ERROR DELETING FILE USER INFO: %@", [error userInfo]);
			NSLog(@"ERROR DELETING FILE LOCALIZED DESCRIPTION: %@", [error localizedDescription]);
			NSLog(@"ERROR DELETING FILE LOCALIZED FAILURE REASON: %@", [error localizedFailureReason]);
		}
		else {
			NSLog(@"Deleted file: %@", file);
		}
	}
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {

}


- (void) dealloc {
	[viewController release];
	[super dealloc];
}

@end
