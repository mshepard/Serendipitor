// 
//  FinalRouteStep.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FinalRouteStep.h"


@implementation FinalRouteStep 

@synthesize timestamp;
@synthesize instruction;
@synthesize photo;
@synthesize location;

-(void) dealloc
{
	[timestamp release];
	[instruction release];
	[photo release];
	[location release];
	[super dealloc];
}

@end
