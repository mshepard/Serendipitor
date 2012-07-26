//
//  Step.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Step.h"


@implementation Step
@synthesize travel_mode ,duration, html_instructions, distance;

- (CLLocationCoordinate2D) start_location
{
	return start_location;
}

- (CLLocationCoordinate2D) end_location
{
	return end_location;
}

-(void) setStartLocationLatitude:(CLLocationDegrees) lat
{
	start_location.latitude = lat;
}

-(void) setStartLocationLongitude:(CLLocationDegrees) lng
{
	start_location.longitude = lng;
}

-(void) setEndLocationLatitude:(CLLocationDegrees) lat
{
	end_location.latitude = lat;
}

-(void) setEndLocationLongitude:(CLLocationDegrees) lng
{
	end_location.longitude = lng;
}


- (void) dealloc {
	[travel_mode release];
	[duration release];
	[html_instructions release];
	[distance release];
	[super dealloc];
}
@end
