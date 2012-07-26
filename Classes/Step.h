//
//  Step.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface Step : NSObject {
	NSString *travel_mode;
	CLLocationCoordinate2D start_location;
	CLLocationCoordinate2D end_location;
	NSNumber *duration;
	NSString *html_instructions;
	NSNumber *distance;
	
}

@property (nonatomic, retain) NSString *travel_mode;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSString *html_instructions;
@property (nonatomic, retain) NSNumber *distance;

- (CLLocationCoordinate2D) start_location;
- (CLLocationCoordinate2D) end_location;
-(void) setStartLocationLatitude:(CLLocationDegrees) lat;
-(void) setStartLocationLongitude:(CLLocationDegrees) lng;
-(void) setEndLocationLatitude:(CLLocationDegrees) lat;
-(void) setEndLocationLongitude:(CLLocationDegrees) lng;

@end
