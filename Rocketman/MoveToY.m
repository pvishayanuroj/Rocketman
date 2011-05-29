//
//  MoveToY.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MoveToY.h"

@implementation MoveToY

+(id) actionWithDuration: (ccTime) t position: (CGPoint) p
{	
	return [[[self alloc] initWithDuration:t position:p ] autorelease];
}

-(id) initWithDuration: (ccTime) t position: (CGPoint) p
{
	if( (self=[super initWithDuration: t]) )
		endPosition = p;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] position: endPosition];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	startPosition = [(CCNode*)target_ position];
	delta = ccpSub( endPosition, startPosition );
}

-(void) update: (ccTime) t
{	
	[target_ setPosition: ccp( ((CCNode *)target_).position.x, (startPosition.y + delta.y * t )) ];
}

@end
