//
//  RockDebris.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "RockDebris.h"
#import "ArcMovement.h"

@implementation RockDebris

+ (id) rockDebris:(CGPoint)pos arcType:(ArcType)arcType arcSide:(ArcSide)arcSide
{
    return [[[self alloc] initRockDebris:pos arcType:arcType arcSide:arcSide] autorelease];
}

- (id) initRockDebris:(CGPoint)pos arcType:(ArcType)arcType arcSide:(ArcSide)arcSide
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Flying Rock Debris.png"] retain];
        [self addChild:sprite_];        
        self.position = pos;
        
        [movements_ addObject:[ArcMovement arcSlowMovement:self.position arcType:arcType arcSide:arcSide]];
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
