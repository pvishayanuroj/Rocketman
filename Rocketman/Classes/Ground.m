//
//  Ground.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Ground.h"
#import "StaticMovement.h"

@implementation Ground

+ (id) groundWithPos:(CGPoint)pos filename:(NSString *)filename
{
    return [[[self alloc] initWithPos:pos filename:filename] autorelease];
}

- (id) initWithPos:(CGPoint)pos filename:(NSString *)filename
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        [self addChild:sprite_];
        
        sprite_.anchorPoint = CGPointZero;
        self.position = pos;
        
        [movements_ addObject:[StaticMovement staticMovement]];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
