//
//  Dino.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Dino.h"
#import "TargetedAction.h"

@implementation Dino

+ (id) dinoWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Dino Idle 01.png"] retain];
        [self addChild:sprite_];
        
        sprite_.position = pos;
        
        [self initActions];
        [self showIdle];
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Dino Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Dino Attack"];
	flameAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}   

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)flameAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}
         
@end
