//
//  Parallax.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Parallax.h"
#import "StaticMovement.h"

@implementation Parallax

const CGFloat PARALLAX_MOVE_SPEED = 0.04f;

+ (id) parallaxWithFile:(NSString *)filename
{
    return [[[self alloc] initWithFile:filename] autorelease];
}

- (id) initWithFile:(NSString *)filename
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        sprite_.anchorPoint = CGPointZero;
        [self addChild:sprite_];
        
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement:PARALLAX_MOVE_SPEED]];           
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
