//
//  Boost.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Boost.h"
#import "GameLayer.h"

@implementation Boost

+ (id) boostWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Boost Ring.png"] retain];
        [self addChild:sprite_];
        
        self.position = pos;
        
        // Attributes
        shootable_ = NO;
        radius_ = 10;
        radiusSquared_ = radius_*radius_;
        
        [self initActions];
        [self showIdle];
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    CCActionInterval *scaleDown = [CCScaleTo actionWithDuration:0.5 scaleX:0.7 scaleY:1.0];
    CCActionInterval *scaleUp = [CCScaleTo actionWithDuration:0.5 scaleX:1.0 scaleY:1.0];    
    CCActionInterval *seq = [CCSequence actions:scaleDown, scaleUp, nil];
	idleAnimation_ = [[CCRepeatForever actionWithAction:seq] retain];		    
    
    /*
    CCActionInterval *scaleUp = [CCScaleBy actionWithDuration:0.15 scale:2.0];
    CCActionInterval *scaleDown = [CCScaleBy actionWithDuration:0.1 scale:0.01];    
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];	    
    collectAnimation_ = [[CCSequence actions:scaleUp, scaleDown, method, nil] retain];
     */
}

- (void) showIdle
{
    [sprite_ stopAllActions];
    [sprite_ runAction:idleAnimation_];	    
}

- (void) showCollect
{
    [sprite_ stopAllActions];
    [sprite_ runAction:collectAnimation_];	        
}

- (void) collide
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer collectBoost:self];
    
    [super collide];
    
    [self destroy];
}

- (void) destroy
{   
    [super destroy];
}


@end
