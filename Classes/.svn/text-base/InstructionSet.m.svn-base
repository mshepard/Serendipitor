//
//  InstructionSet.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InstructionSet.h"


@implementation InstructionSet
@synthesize instructions;

- (InstructionSet *) initWithContentsOfFile:(NSString *)filename
{
	instructions = [[NSMutableArray alloc] initWithCapacity:0];
	
	NSString *CSV = [self readFromFile:filename];
	
	if (CSV) {
		[self parseInstructions:CSV];
	}
	
	return self;
}

-(NSString *) readFromFile:(NSString *)filename
{
	NSError *error;
	NSString *path = [[NSBundle mainBundle] bundlePath];
	
	NSString *result = [[[NSString alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",path,filename] encoding:NSUTF8StringEncoding error:&error] autorelease];
	
	if (!result) {
		NSLog(@"ERROR READING CSV USER INFO: %@", [error userInfo]);
		NSLog(@"ERROR READING CSV LOCALIZED DESCRIPTION: %@", [error localizedDescription]);
		NSLog(@"ERROR READING CSV LOCALIZED FAILURE REASON: %@", [error localizedFailureReason]);
	}
	
	return result;
}


-(void) parseInstructions:(NSString *) CSV
{
	NSArray *rows = [CSV componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]];
	NSArray *rowArray;
	
	
	for (NSString *row in rows)
	{
		if([row characterAtIndex:0] == '\"')
		{
			rowArray = [[row substringFromIndex:1] componentsSeparatedByString:@"\","];
		}
		else {
			rowArray = [row componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		}
		
		NSString *instruction = [rowArray objectAtIndex:0];
		NSString *type = [rowArray objectAtIndex:1];
		CustomInstruction *inst = [[CustomInstruction alloc] initWithInstruction:instruction type:type];
		
		[instructions addObject:inst];
		[inst release];
	}
}


- (void) dealloc {
	[instructions release];
	[super dealloc];
}
@end
