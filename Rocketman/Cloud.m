//
//  Cloud.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Cloud.h"


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
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
