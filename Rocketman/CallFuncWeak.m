//
//  CallFuncWeak.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CallFuncWeak.h"

@implementation CallFuncWeak

@synthesize targetCallback = targetCallback_;

+(id) actionWithTarget: (id) t selector:(SEL) s
{
	return [[[self alloc] initWithTarget: t selector: s] autorelease];
}

-(id) initWithTarget: (id) t selector:(SEL) s
{
	if( (self=[super init]) ) {
		self.targetCallback = t;
		selector_ = s;
	}
	return self;
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ = %08X | Tag = %i | target = %@ | selector = %@>",
			[self class],
			self,
			tag_,
			[targetCallback_ class],
			NSStringFromSelector(selector_)
			];
}

-(void) dealloc
{
	//[targetCallback_ release]; // DO NOT USE THIS, SINCE WE ARE NOT RETAINING
	[super dealloc];
}

-(id) copyWithZone: (NSZone*) zone
{
	CCActionInstant *copy = [[[self class] allocWithZone: zone] initWithTarget:targetCallback_ selector:selector_];
	return copy;
}

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	[self execute];
}

-(void) execute
{
	[targetCallback_ performSelector:selector_];
}
@end
