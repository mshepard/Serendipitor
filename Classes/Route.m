//
//  Direction.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Route.h"


@implementation Route
@synthesize waypoints, travel_mode, legs, status, isSucessfullyParsed, currentLeg, currentStep, currentElementValue, currentElementName, polyLine;

-(id)initWithStart:(CLLocationCoordinate2D)st end:(CLLocationCoordinate2D)en waypoints:(NSMutableArray*)wp
{
	[super init];
	start = st;
	end = en;
	
	self.waypoints = [[[NSMutableArray alloc] initWithArray:wp] autorelease];
	self.status = @"";
	self.travel_mode = @"";
	self.isSucessfullyParsed = [NSNumber numberWithBool:NO];
	
	[self requestDirectionsWithMode:@"walking"];
	
	if ([self.isSucessfullyParsed boolValue]) {
		return self;
	}
	else {
		return nil;
	}
}

-(id)initWithStart:(CLLocationCoordinate2D)st end:(CLLocationCoordinate2D)en
{
	[super init];
	start = st;
	end = en;
	self.waypoints = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	self.isSucessfullyParsed = [NSNumber numberWithBool:NO];
	self.status = @"";
	self.travel_mode = @"";
	
	[self requestDirectionsWithMode:@"walking"];
	
	if ([self.status isEqualToString:@"ZERO_RESULTS"]) {
		NSLog(@"No walking directions found getting driving directions");
		[self requestDirectionsWithMode:@"driving"];
	}
	
	if ([self.isSucessfullyParsed boolValue]) {
		return self;
	}
	else {
		return nil;
	}
}

- (NSNumber *) fullDuration
{
	NSNumber *dur = [NSNumber numberWithInt:0];
	for(Leg *leg in legs)
	{	
		dur = [NSNumber numberWithInt:[dur intValue]+[leg.duration intValue]];
	}
	//NSLog(@"FULL DURATION ASKED: %@", dur);
	return dur;
}

- (NSNumber *) fullDistance
{
	NSNumber *dis = [NSNumber numberWithInt:0];
	for(Leg *leg in legs)
	{	
		dis = [NSNumber numberWithInt:[dis intValue]+[leg.distance intValue]];
	}
	//NSLog(@"FULL DISTANCE ASKED: %@", dis);
	return dis;
}


-(void)requestDirectionsWithMode:(NSString *)mode
{	
	NSString *urlString;
	
	if ([waypoints count] > 0) {
		NSMutableString *wp = [[NSMutableString alloc] initWithString:@"waypoints=optimize:true%7C"];
		for (CLLocation *loc in waypoints) {
			[wp appendFormat:@"%f,%f%%7C",loc.coordinate.latitude, loc.coordinate.longitude];
		}
		NSString *wpOption = [wp stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"%%7C"]];
		
		urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/api/directions/xml?origin=%@&destination=%@&%@&mode=%@&sensor=true", 
							   [self stringWithCoordinates:start], [self stringWithCoordinates:end], wpOption, mode];
		[wp release];
	}
	else {
		urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/api/directions/xml?origin=%@&destination=%@&mode=%@&sensor=true", 
					 [self stringWithCoordinates:start], [self stringWithCoordinates:end], mode];
	}

	NSLog(@"\n\n\nURL DUMP:%@\n\n\n", urlString);
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
	
	if (parser != nil) {
		parser.delegate = self;
	}
	else {
		NSLog(@"Error calling Google Maps for directions");
		[parser release];
		return;
	}
	
	
	
	BOOL success = [parser parse];
	[parser abortParsing];
	[parser release];
	
	if(!success || ![self.status isEqualToString:@"OK"]){ 
		self.isSucessfullyParsed = [NSNumber numberWithBool:NO];
	}
	else { 
		self.isSucessfullyParsed = [NSNumber numberWithBool:YES];
	}
}


-(NSString*) stringWithCoordinates:(CLLocationCoordinate2D)coords
{
	return [NSString stringWithFormat:@"%f,%f", coords.latitude, coords.longitude];
}


#pragma mark -
#pragma mark XMLParser delegate

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"ERROR PARSING XML USER INFO: %@", [parseError userInfo]);
	NSLog(@"ERROR PARSING XML LOCALIZED DESCRIPTION: %@", [parseError localizedDescription]);
	NSLog(@"ERROR PARSING XML LOCALIZED FAILURE REASON: %@", [parseError localizedFailureReason]);
}


- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	//NSLog(@"Starting XML document");
	self.legs = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"leg"]) {
		self.currentLeg = [[[Leg alloc] init] autorelease];
		//NSLog(@"Started Leg");
	}
	else if ([elementName isEqualToString:@"step"]) {
		self.currentStep = [[[Step alloc] init] autorelease];
		//NSLog(@"	Started step");
	}
	else if ([elementName isEqualToString:@"start_location"]) {
		self.currentElementName = elementName;
		//NSLog(@"		Getting start Location");
	}
	else if ([elementName isEqualToString:@"end_location"]) {
		self.currentElementName = elementName;
		//NSLog(@"		Getting end Location");
	}
	else if ([elementName isEqualToString:@"duration"]) {
		self.currentElementName = elementName;
		//NSLog(@"		Getting duration");
	}
	else if ([elementName isEqualToString:@"distance"]) {
		self.currentElementName = elementName;
		//NSLog(@"		Getting distance");
	}else if ([elementName isEqualToString:@"overview_polyline"]) {
		self.currentElementName = elementName;
		//NSLog(@"		Getting distance");
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if(currentElementValue)
	{
		[currentElementValue setString:[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
	}
	
	if ([elementName isEqualToString:@"status"]) {
		self.status = [currentElementValue stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		//NSLog(@"got the status: %@", self.status);
	}
	else if ([elementName isEqualToString:@"leg"]) {
		[self.legs addObject:currentLeg];
		
		self.currentLeg = nil;
		//NSLog(@"finished leg");
	}
	else if ([elementName isEqualToString:@"step"]) {
		[self.currentLeg.steps addObject:currentStep];
		
		self.currentStep =nil;
		//NSLog(@"	finished step");
	}
	else if ([elementName isEqualToString:@"lat"] && currentStep) 
	{
		if ([currentElementName isEqualToString:@"start_location"]) 
		{
			[currentStep setStartLocationLatitude:[currentElementValue floatValue]];
			
			//NSLog(@"		got start location lat: %f", currentStep.start_location.latitude);
		}
		else if ([currentElementName isEqualToString:@"end_location"])
		{
			[currentStep setEndLocationLatitude:[currentElementValue floatValue]];
			
			//NSLog(@"		got end location lat: %f", currentStep.end_location.latitude);
		}
	}
	else if ([elementName isEqualToString:@"lng"] && currentStep) 
	{
		if ([currentElementName isEqualToString:@"start_location"]) {
			[currentStep setStartLocationLongitude:[currentElementValue floatValue]];
			
			//NSLog(@"		got start location lng: %f", currentStep.start_location.longitude);
		}
		else if ([currentElementName isEqualToString:@"end_location"])
		{
			[currentStep setEndLocationLongitude:[currentElementValue floatValue]];
			
			//NSLog(@"		got end location lng: %f", currentStep.end_location.longitude);
		}
	}
	else if ([elementName isEqualToString:@"value"]) 
	{
		if ([currentElementName isEqualToString:@"duration"] && currentStep) {
			currentStep.duration = [NSNumber numberWithInt:[currentElementValue intValue]];
			//NSLog(@"		got duration: %@ seconds", currentStep.duration);
		}
		if ([currentElementName isEqualToString:@"duration"] && !currentStep) {
			currentLeg.duration = [NSNumber numberWithInt:[currentElementValue intValue]];
			//NSLog(@"		got a Leg duration: %@ seconds", currentLeg.duration);
		}
		if ([currentElementName isEqualToString:@"distance"] && currentStep) {
			currentStep.distance = [NSNumber numberWithInt:[currentElementValue intValue]];
			//NSLog(@"		got distance: %@ meters", currentStep.duration);
		}
		if ([currentElementName isEqualToString:@"distance"] && !currentStep) {
			currentLeg.distance = [NSNumber numberWithInt:[currentElementValue intValue]];
			//NSLog(@"		got a Leg distance: %@ meters", currentLeg.duration);
		}
		
	}
	else if ([elementName isEqualToString:@"html_instructions"]) 
	{
		currentStep.html_instructions = currentElementValue;
		//NSLog(@"		got instructions: %@", currentStep.html_instructions);
	}
	else if ([elementName isEqualToString:@"points"] && [currentElementName isEqualToString:@"overview_polyline"]) 
	{
		self.polyLine = [[NSMutableString alloc] initWithString:currentElementValue];
		NSLog(@"		got polyLine: %@", self.polyLine);
	}
	else if ([elementName isEqualToString:@"start_location"] || [elementName isEqualToString:@"end_location"] || [elementName isEqualToString:@"duration"] || [elementName isEqualToString:@"distance"] || [elementName isEqualToString:@"overview_polyline"])
	{
		self.currentElementName = nil;
	}
	
	self.currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if ([string isEqualToString:@"\n"]) {
		return;
	}
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void) dealloc {
	[waypoints release];
	
	[status release];
	[travel_mode release];
	[legs release];
	[polyLine release];
	[isSucessfullyParsed release];
	[currentElementValue release];
	[currentElementName release];
	
	[super dealloc];
}

@end
