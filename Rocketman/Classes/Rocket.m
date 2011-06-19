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
#import "EngineParticleSystem.h"
#import "AudioManager.h"

@implementation Rocket

@synthesize rect = rect_;

#pragma mark - Object Lifecycle

+ (id) rocketWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket2 Fly 01.png"] retain];
        [self addChild:sprite_ z:-2];
        
        self.position = pos;
        
        isBurning_ = NO;
        isWobbling_ = NO;
        isHeart_ = NO;
        
        rect_.origin = CGPointZero;
        rect_.size.height = 60;
        rect_.size.width = 10;
        
        [self initEngineFlame];
        [self initActions];
        
	}
	return self;
}

- (void) dealloc
{
    NSLog(@"Rocket dealloc'd");    
    
    [sprite_ release];
    [flyingAnimation_ release];
    [shakingAnimation_ release];
    [burningAnimation_ release];
    [wobblingAnimation_ release];
    [heartAnimation_ release];
    [engineFlame_ release];
    [boostFlame_ release];
    [heartParticles_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Player Rocket"];
}    

#pragma mark - Initialization Methods

- (void) initEngineFlame
{
    engineFlame_ = [[EngineParticleSystem PSForRocketFlame] retain];
	[self addChild:engineFlame_ z:-3];
    engineFlame_.position = CGPointMake(0, -30);
    
    boostFlame_ = [[EngineParticleSystem PSForBoostFlame] retain];
	[self addChild:boostFlame_ z:-3];    
    boostFlame_.position = CGPointMake(0, -30);  
    
    heartParticles_ = [[EngineParticleSystem PSForRocketHearts] retain];
	[self addChild:heartParticles_ z:-1];    
    heartParticles_.position = CGPointMake(0, -30);      
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket2 Fly"];
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

    shakingAnimation_ = [[CCSequence actions:a1, a2, a3, a4, nil] retain];
    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket2 Burn"];
	burningAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
    
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket2 Wobble"];
	wobblingAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
    
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket2 Heart"];
	heartAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
}        

#pragma mark - Animated Sequences

- (void) showFlying
{
	//[sprite_ stopAllActions];
	//[sprite_ runAction:flyingAnimation_];	
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
    if (isBurning_ || isWobbling_) {
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

- (void) showWobbling
{
    if (isWobbling_ || isBurning_) {
        return;
    }
    
    isWobbling_ = YES;
	[sprite_ stopAllActions];	
	
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)wobblingAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneWobbling)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) doneWobbling
{
    isWobbling_ = NO;
    [self showFlying];
}

- (void) showHeart
{
    if (isHeart_) {
        return;
    }
    
    isHeart_ = YES;
    [sprite_ stopAllActions];
    
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)heartAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneHeartAnimation)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
    
    // Activate particle system
    heartParticles_.emissionRate = heartParticles_.totalParticles/heartParticles_.life;
}

- (void) doneHeartAnimation
{
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket2 Heart 03.png"] retain];
    [self addChild:sprite_ z:-2];    
    
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:2.0f];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneHeartSequence)];	    
    
    [self runAction:[CCSequence actions:delay, method, nil]];
}

- (void) doneHeartSequence
{
    isHeart_ = NO;    
    
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket2 Fly 01.png"] retain];
    [self addChild:sprite_ z:-2];        
    
    heartParticles_.emissionRate = 0;    
}

#pragma mark - Particle System

- (void) toggleBoostOn:(BOOL)on
{
    if (on) {
        engineFlame_.emissionRate = 0;
        boostFlame_.emissionRate = boostFlame_.totalParticles/boostFlame_.life;
        [[AudioManager audioManager] playSound:kEngine];
    }
    else {
        boostFlame_.emissionRate = 0;
        engineFlame_.emissionRate = engineFlame_.totalParticles/engineFlame_.life;        
        [[AudioManager audioManager] stopSound:kEngine];
    }
}

- (void) turnFlameOff
{
    engineFlame_.emissionRate = 0;
    boostFlame_.emissionRate = 0;
}

#pragma mark - Debug Methods

#if DEBUG_BOUNDINGBOX
- (void) draw
{
    // top left
    CGPoint p1 = ccp(rect_.origin.x - rect_.size.width / 2, rect_.origin.y + rect_.size.height / 2);
    // top right
    CGPoint p2 = ccp(rect_.origin.x + rect_.size.width / 2, rect_.origin.y + rect_.size.height / 2);
    // bottom left
    CGPoint p3 = ccp(rect_.origin.x - rect_.size.width / 2, rect_.origin.y - rect_.size.height / 2);
    // bottom right
    CGPoint p4 = ccp(rect_.origin.x + rect_.size.width / 2, rect_.origin.y - rect_.size.height / 2);    
    
    glColor4f(1.0, 0, 0, 1.0);            
    ccDrawLine(p1, p2);
    ccDrawLine(p3, p4);    
    ccDrawLine(p2, p4);
    ccDrawLine(p1, p3);    
}
#endif

@end
