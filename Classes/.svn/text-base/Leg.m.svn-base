//
//  Leg.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Leg.h"


@implementation Leg
@synthesize steps, duration, distance, start_address, end_address;

-(id) init
{
	self.steps = [[NSMutableArray alloc] initWithCapacity:0];
	[super init];
	return self;
}

- (void) dealloc {
	[steps release];
	[duration release];
	[distance release];
	[start_address release];
	[end_address release];
	[super dealloc];
}

@end
