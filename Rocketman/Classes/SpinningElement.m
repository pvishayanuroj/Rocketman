//
//  SpinningElement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SpinningElement.h"


@implementation SpinningElement

+ (id) spinningElementAWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;
{
    return [[[self alloc] initAWithFile:filename from:from to:to duration:duration] autorelease];
}

+ (id) spinningElementBWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;
{
    return [[[self alloc] initBWithFile:filename from:from to:to duration:duration] autorelease];
}

- (id) initAWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;
{
    if ((self = [super init])) {
        
        self.position = from;        
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        [self addChild:sprite_];
        
        CGFloat rotPerSec = 1.0;
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:2.0];
        
        CCFiniteTimeAction *spin = [CCRotateBy actionWithDuration:duration angle:(360 * duration * rotPerSec)];
        CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:duration position:to];
        CCFiniteTimeAction *actions = [CCSpawn actions:spin, move, nil];
        action_ = [[CCSequence actions:delay, actions, nil] retain];
    }
    return self;
}

- (id) initBWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;
{
    if ((self = [super init])) {
        
        self.position = from;        
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        [self addChild:sprite_];
        
        CGFloat rotPerSec = 1.0;
        CCFiniteTimeAction *spin = [CCRotateBy actionWithDuration:duration angle:(360 * duration * rotPerSec)];
        CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:duration position:to];
        CCFiniteTimeAction *shrink = [CCScaleTo actionWithDuration:duration scale:0];
        action_ = [[CCSpawn actions:spin, move, shrink, nil] retain];
        
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
