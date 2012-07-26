//
//  CustomInstruction.h
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomInstruction : NSObject {
	NSString *instruction;
	NSString *type;
}

@property (nonatomic, retain) NSString *instruction;
@property (nonatomic, retain) NSString *type;

-(CustomInstruction *) initWithInstruction:(NSString *)i type:(NSString *)t;

@end
