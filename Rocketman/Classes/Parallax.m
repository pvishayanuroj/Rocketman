//
//  Parallax.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Parallax.h"


@implementation Parallax

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
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed * 0.04f);
    self.position = ccpSub(self.position, p);    
}

@end
