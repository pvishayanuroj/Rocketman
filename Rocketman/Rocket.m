//
//  Rocket.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Rocket.h"
#import "GameLayer.h"
#import "TargetedAction.h"
#import "CallFuncWeak.h"

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
        
        self.position = pos;
        
        isBurning_ = NO;
        
        [self initActions];
        
	}
	return self;
}

- (void) dealloc
{
    NSLog(@"Game Layer dealloc'd");    
    
    [sprite_ release];
    [flyingAnimation_ release];
    [shakingAnimation_ release];
    [burningAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket Fly"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	flyingAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		

    // Issue where simulator runs slower than the iPhone
#if defined(__ARM_NEON__) || defined(__MAC_OS_X_VERSION_MAX_ALLOWED) || TARGET_IPHONE_SIMULATOR
    CGFloat speed = 0.04;
    NSUInteger times = 25;    
#elif __arm__
    CGFloat speed = 0.02;
    NSUInteger times = 50;    
#else
    #error(unknown architecture)
#endif    
    
    CCActionInterval *l1 = [CCMoveTo actionWithDuration:speed position:CGPointMake(-1.25, 0)];
    CCActionInterval *r1 = [CCMoveTo actionWithDuration:speed position:CGPointMake(1.25, 0)];    
    CCActionInterval *l2 = [CCMoveTo actionWithDuration:speed position:CGPointMake(-1, 0)];
    CCActionInterval *r2 = [CCMoveTo actionWithDuration:speed position:CGPointMake(1, 0)];    
    CCActionInterval *l3 = [CCMoveTo actionWithDuration:speed position:CGPointMake(-0.75, 0)];
    CCActionInterval *r3 = [CCMoveTo actionWithDuration:speed position:CGPointMake(0.75, 0)];        
	
    CCActionInterval *s1 = [CCSequence actions:l1, r1, nil];
    CCActionInterval *s2 = [CCSequence actions:l2, r2, nil];
    CCActionInterval *s3 = [CCSequence actions:l3, r3, nil];    
    
    CCActionInterval *a1 = [CCRepeat actionWithAction:s1 times:times];
    CCActionInterval *a2 = [CCRepeat actionWithAction:s2 times:times];
    CCActionInterval *a3 = [CCRepeat actionWithAction:s3 times:times];
    CCActionInstant *a4 = [CallFuncWeak actionWithTarget:self selector:@selector(doneShaking)];
    //CCActionInterval *a4 = [CCMoveTo actionWithDuration:speed position:CGPointZero];

    shakingAnimation_ = [[CCSequence actions:a1, a2, a3, a4, nil] retain];
    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket Burn"];
	burningAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}        

- (void) realignSprite
{
    sprite_.position = CGPointZero;
}

- (void) showFlying
{
	[sprite_ stopAllActions];
	[sprite_ runAction:flyingAnimation_];	
}

- (void) showShaking
{
    [sprite_ stopAllActions];
    [sprite_ runAction:shakingAnimation_];
}
                           
- (void) doneShaking
{
    sprite_.position = CGPointZero;
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer takeOffComplete];
    
    [self showFlying];
}
                             
- (void) showBurning
{
    if (isBurning_) {
        return;
    }
    
    isBurning_ = YES;
	[sprite_ stopAllActions];	
	
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)burningAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneBurning)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) doneBurning
{
    isBurning_ = NO;
    [self showFlying];
}

@end
