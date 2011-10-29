//
//  Cloud.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Cloud.h"
#import "StaticMovement.h"

@implementation Cloud

+ (id) cloudWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        NSInteger rand = 1 + arc4random() % 2;
        sprite_ = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Cloud %02d.png", rand]] retain];
        [self addChild:sprite_];
        self.position = pos;
        
        CGFloat rand2 = arc4random() % 10;
        rand2 *= 0.02f;
        rand2 -= 0.1f;
        sprite_.scale = 1 + rand2;
        
        // Setup the way this obstacle moves
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
