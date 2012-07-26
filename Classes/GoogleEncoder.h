//
//  GoogleEncoder.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface GoogleEncoder : NSObject {
	NSArray * locations;
}

@property (nonatomic, retain) NSArray *locations;

-(id) initWithLocations:(NSArray *)locs;
- (NSString *) googlePolyline;

@end
