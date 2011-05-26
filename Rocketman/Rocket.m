//
//  Rocket.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Rocket.h"
#import "TargetedAction.h"

@implementation Rocket

+ (id) rocketWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket Fly 01.png"] retain];
        [self addChild:sprite_];
        
        sprite_.position = pos;
        
        [self initActions];
        
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
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket Fly"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	flyingAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket Burn"];
	burningAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}        

- (void) showFlying
{
	[sprite_ stopAllActions];
	[sprite_ runAction:flyingAnimation_];	
}

- (void) showBurning
{
	[sprite_ stopAllActions];	
	
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)burningAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneBurning)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}
         
- (void) doneBurning
{
    
}

@end
