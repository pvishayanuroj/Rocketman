//
//  Ground.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Ground.h"


@implementation Ground

+ (id) groundWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:@"ground.png"] retain];
        [self addChild:sprite_];
        
        sprite_.anchorPoint = CGPointZero;
        self.position = pos;
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
