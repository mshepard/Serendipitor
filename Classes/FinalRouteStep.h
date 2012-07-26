//
//  FinalRouteStep.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface FinalRouteStep :  NSObject  
{
	NSDate * timestamp;
	NSString * instruction;
	NSString * photo;
	NSString * location;
}

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * instruction;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSString * location;

@end



