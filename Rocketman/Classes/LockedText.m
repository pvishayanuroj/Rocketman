//
//  LockedText.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/4/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "LockedText.h"


@implementation LockedText

const CGFloat LT_SHAKESPEED = 0.02f;
const CGFloat LT_NUMSHAKES = 5;
const CGFloat LT_SHAKEOFFSET = 2.0f;

#pragma mark - Object Lifecycle

+ (id) lockedText
{
    return [[[self alloc] initLockedText] autorelease];
}

- (id) initLockedText
{
    if ((self = [super init])) {
        
        CCSprite *sprite = [CCSprite spriteWithFile:R_LOCKED_TEXT];
        [self addChild:sprite];
        
        [self runShaking];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - Object Manipulation Methods

- (void) runShaking
{
    CGFloat speed = LT_SHAKESPEED;
    NSUInteger times = LT_NUMSHAKES;
    
    // For shaking
    CCActionInterval *l1 = [CCMoveBy actionWithDuration:speed position:CGPointMake(0, LT_SHAKEOFFSET)];
    CCActionInterval *r1 = [CCMoveBy actionWithDuration:speed position:CGPointMake(0, -LT_SHAKEOFFSET)];           
	
    CCActionInterval *s1 = [CCSequence actions:l1, r1, nil];    
    
    CCActionInterval *a1 = [CCRepeat actionWithAction:s1 times:times];
    CCActionInstant *a2 = [CCCallFunc actionWithTarget:self selector:@selector(doneShaking)];
    
    [self runAction:[CCSequence actions:a1, a2, nil]];    
}

- (void) doneShaking
{
    [self removeFromParentAndCleanup:YES];
}


@end
