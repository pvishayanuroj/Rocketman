//
//  Cat.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Cat.h"
#import "GameLayer.h"

@implementation Cat

+ (id) catWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Idle 01.png"] retain];
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
    CCActionInterval *animate = [CCRotateBy actionWithDuration:2.0 angle:360];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		    
    
    CCActionInterval *scaleUp = [CCScaleBy actionWithDuration:0.15 scale:2.0];
    CCActionInterval *scaleDown = [CCScaleBy actionWithDuration:0.1 scale:0.01];    
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];	    
    collectAnimation_ = [[CCSequence actions:scaleUp, scaleDown, method, nil] retain];
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
    [gameLayer collectCat:self];    
    
    [self showCollect];
    
    [super collide];
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
    
    [super destroy];
}

@end
