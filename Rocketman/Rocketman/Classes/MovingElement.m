//
//  MovingElement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MovingElement.h"


@implementation MovingElement

+ (id) movingElementWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to delay:(CGFloat)timeDelay duration:(CGFloat)duration
{
    return [[[self alloc] initWithFile:filename from:from to:to delay:timeDelay duration:duration] autorelease];
}

- (id) initWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to delay:(CGFloat)timeDelay duration:(CGFloat)duration
{
    if ((self = [super init])) {
        
        self.position = from;        
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        [self addChild:sprite_];
        
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:timeDelay];
        
        CCActionInterval *move = [CCMoveTo actionWithDuration:duration position:to];
        CCFiniteTimeAction *ease = [CCEaseIn actionWithAction:move rate:2.0];
        action_ = [[CCSequence actions:delay, ease, nil] retain];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [action_ release];
    
    [super dealloc];
}

- (void) play   
{
    [self runAction:action_];
}

@end
