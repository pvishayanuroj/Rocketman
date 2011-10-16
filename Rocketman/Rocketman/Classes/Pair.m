//
//  Pair.m
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Pair.h"

@implementation Pair

@synthesize x, y;

+ (id) pair
{
	return [[[self alloc] initPair:0 second:0] autorelease];
}

+ (id) pair:(NSInteger)a second:(NSInteger)b
{
	return [[[self alloc] initPair:a second:b] autorelease];
}

+ (id) pairWithPair:(Pair *)p
{
	return [[[self alloc] initPair:p.x second:p.y] autorelease];
}

+ (Pair *) addPair:(Pair *)a withPair:(Pair *)b
{
	return [Pair pair:(a.x+b.x) second:(a.y+b.y)];
}

+ (Pair *) subtractPair:(Pair *)a withPair:(Pair *)b
{
	return [Pair pair:(a.x-b.x) second:(a.y-b.y)];
}

+ (BOOL) pairsEqual:(Pair *)a withPair:(Pair *)b
{
	return (a.x == b.x && a.y == b.y);
}

- (id) initPair:(NSInteger)a second:(NSInteger)b
{
	if ((self = [super init]))
	{
		x = a;
		y = b;
	}
	return self;
}

- (void) addWithPair:(Pair *)p
{
	x += p.x;
	y += p.y;
}

- (void) subtractWithPair:(Pair *)p
{
	x -= p.x;
	y -= p.y;
}

- (Pair *) leftPair
{
	return [Pair pair:x-1 second:y];
}

- (Pair *) rightPair
{
	return [Pair pair:x+1 second:y];
}

- (Pair *) topPair
{
	return [Pair pair:x second:y+1];
}

- (Pair *) bottomPair
{
	return [Pair pair:x second:y-1];
}

- (NSArray *) getAdjacentPairs
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    
    [array addObject:[self topPair]];
    [array addObject:[self bottomPair]];
    [array addObject:[self leftPair]];
    [array addObject:[self rightPair]];    
    
    return array;
}

- (void) invertPair
{
	x *= -1;
	y *= -1;
}

- (void) setEqualWith:(Pair *)p
{
	x = p.x;
	y = p.y;
}

- (id) copyWithZone: (NSZone *)zone
{
	Pair *pairCopy = [[Pair allocWithZone:zone] init];
	pairCopy.x = self.x;
	pairCopy.y = self.y;
	return pairCopy;
}

- (NSUInteger) hash
{
	// Not the best hash function, but it will do
	//NSUInteger hashNum = x + y;
	NSUInteger hashNum = 1024*x + y;
	return hashNum;	
}

- (BOOL) isEqual:(id)anObject
{
	if ([anObject isKindOfClass:[Pair class]]) {
		Pair *otherPair= (Pair *)anObject;
		return (self.x == otherPair.x && self.y == otherPair.y);
	}
	return NO;
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"(%d, %d)", x, y];
}

- (void) dealloc
{
	[super dealloc];
}

@end