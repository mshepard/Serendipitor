//
//  CustomPlaceMark.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CustomPlaceMark.h"

@implementation CustomPlaceMark
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


-(id)initWithCoordinate:(CLLocationCoordinate2D) coord{
	coordinate=coord;
	return self;
}

- (void)dealloc {
	[title release];
	[subtitle release];
	[super dealloc];
}

@end
