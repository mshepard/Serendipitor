//
//  InstructionSet.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomInstruction.h"

@interface InstructionSet : NSObject {
	NSMutableArray *instructions;
	NSScanner *scanner;
}

@property(nonatomic, retain) NSMutableArray *instructions;

-(NSString *) readFromFile:(NSString *)filename;
-(void) parseInstructions:(NSString *) CSV;

@end
