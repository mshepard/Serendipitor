//
//  GoggleEncoder.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleEncoder.h"

@interface GoogleEncoder (PrivateMethods)

- (int) floor1e5: (double) coordinate;
- (NSString *) encodeSignedNumber: (int) num;
- (NSString *) encodeNumber: (int) num;

@end


@implementation GoogleEncoder
@synthesize locations;

-(id) initWithLocations:(NSArray *)locs
{
	[super init];
	locations = [[NSArray alloc] initWithArray:locs];
	
	return self;
}

- (int) floor1e5: (double) coordinate {
	return (int) floor(coordinate * 1e5);
}

- (NSString *) encodeSignedNumber: (int) num {
	int sgn_num = num << 1;
	if (num < 0) {
		sgn_num = ~(sgn_num);
	}
	return [self encodeNumber: sgn_num];
}

- (NSString *) encodeNumber: (int) num {
	int nextValue;
	NSMutableString *encodeString = [[NSMutableString alloc] initWithCapacity:5];
	[encodeString autorelease];
	
	while (num >= 0x20) {
		nextValue = (0x20 | (num & 0x1f)) + 63;
		[encodeString appendFormat:@"%c", ((char) (nextValue))];
		num >>= 5;
	}
	
	num += 63;
	[encodeString appendFormat:@"%c", ((char) (num))];
	
	return encodeString;
}

- (NSString *) googlePolyline {
	int i, late5, lnge5, dlat, dlng, plat, plng;
	
	if ([locations count] == 0) {
		return @"";
	}
	
	NSMutableString *encodedPoints = [[NSMutableString alloc] initWithCapacity:100];
	[encodedPoints autorelease];
	CLLocation *tmploc;
	
	plat = 0;
	plng = 0;
	
	for (i = 0; i < [locations count]; i++) {
		tmploc = [locations objectAtIndex:i];
		
		late5 = [self floor1e5: tmploc.coordinate.latitude];
		lnge5 = [self floor1e5: tmploc.coordinate.longitude];
		
		dlat = late5 - plat;
		dlng = lnge5 - plng;
		
		plat = late5;
		plng = lnge5;
		
		[encodedPoints appendFormat:@"%@%@", [self encodeSignedNumber:dlat], [self encodeSignedNumber:dlng]];
		
	}
	return [[[NSString alloc] initWithFormat: @"%@", encodedPoints] autorelease];
}


- (void) dealloc {
	[locations release];
	[super dealloc];
}
@end
