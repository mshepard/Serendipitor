//
//  Route.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Leg.h"
#import "Step.h"

@interface Route : NSObject <NSXMLParserDelegate>{
	//For the parser
	Leg *currentLeg;
	Step *currentStep;
	NSMutableString *currentElementValue;
	NSString *currentElementName;
	
	//To send to Google Maps
	CLLocationCoordinate2D start;
	CLLocationCoordinate2D end;
	NSMutableArray *waypoints;

	//To Receive from Google Maps
	NSString *status;
	NSString *travel_mode;
	NSMutableArray *legs;
	NSMutableString *polyLine;
	NSNumber *isSucessfullyParsed;
}

@property (nonatomic, retain) Leg *currentLeg;
@property (nonatomic, retain) Step *currentStep;
@property (nonatomic, retain) NSMutableString *currentElementValue;
@property (nonatomic, retain) NSString *currentElementName;

@property (nonatomic, retain) NSMutableArray *waypoints;

@property (nonatomic, retain) NSString *travel_mode;
@property (nonatomic, retain) NSMutableArray *legs;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSMutableString *polyLine;
@property (nonatomic, retain) NSNumber *isSucessfullyParsed;

-(id)initWithStart:(CLLocationCoordinate2D)st end:(CLLocationCoordinate2D)en waypoints:(NSMutableArray*)wp;
-(id)initWithStart:(CLLocationCoordinate2D)st end:(CLLocationCoordinate2D)en;

- (NSNumber *) fullDuration;
- (NSNumber *) fullDistance;
-(void)requestDirectionsWithMode:(NSString *)mode;

-(NSString*) stringWithCoordinates:(CLLocationCoordinate2D)coords;

@end
