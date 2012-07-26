//
//  CustomInstruction.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomInstruction.h"


@implementation CustomInstruction
@synthesize instruction, type;

-(CustomInstruction *) initWithInstruction:(NSString *)i type:(NSString *)t
{
	[super init];
	instruction = [[NSString alloc] initWithString:i];
	type = [[NSString alloc] initWithString:t];
	
	return self;
}

-(void) dealloc {
	[instruction release];
	[type release];
	[super dealloc];
}
@end
