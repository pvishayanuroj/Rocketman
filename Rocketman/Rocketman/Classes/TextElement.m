//
//  TextElement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TextElement.h"


@implementation TextElement

+ (id) textElementWithFile:(NSString *)filename at:(CGPoint)pos;
{
    return [[[self alloc] initWithFile:filename at:pos] autorelease];
}

- (id) initWithFile:(NSString *)filename at:(CGPoint)pos;
{
    if ((self = [super init])) {
        
        self.position = pos;        
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        [self addChild:sprite_];
        sprite_.opacity = 0;
        
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:1.5];
        CCFiniteTimeAction *appear = [CCFadeIn actionWithDuration:0.05];
        action_ = [[CCSequence actions:delay, appear, nil] retain];
        

    }
    return self;
}

- (void) play   
{
    [sprite_ runAction:action_];
}

- (void) dealloc
{
    [sprite_ release];
    [action_ release];
    
    [super dealloc];
}

@end
