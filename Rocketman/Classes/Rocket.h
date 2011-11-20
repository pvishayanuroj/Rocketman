//
//  Rocket.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "RocketDelegate.h"

/** Rocket states */
typedef enum {
    kIdle,
    kShaking,
    //kBoosting,
    kBurning,
    kWobbling,
    kHeart,
    kSlow
    
} RocketState;

@interface Rocket : CCNode {
    
    RocketState rocketState_;
    
    CCSprite *sprite_;
 
    CCSprite *aura_;
    
    CCAction *flyingAnimation_;
    
    CCAction *burningAnimation_;
    
    CCAction *shakingAnimation_;    
    
    CCAction *repeatableShakingAnimation_;
    
    CCAction *wobblingAnimation_;
    
    CCAction *slowAnimation_;    
    
    CCAction *heartAnimation_;
    
    CCAction *auraAnimation_;    
    
    BOOL isInvincible_;
    
    CGRect rect_;
    
	CCParticleSystem *engineFlame_;    
    
	CCParticleSystem *boostFlame_;         
    
	CCParticleSystem *heartParticles_;
    
    id <RocketDelegate> delegate_;
}

@property (nonatomic, readonly) CGRect rect;
@property (nonatomic, readonly) BOOL isInvincible;
@property (nonatomic, readonly) RocketState rocketState;
@property (nonatomic, assign) id <RocketDelegate> delegate;

+ (id) rocketWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initEngineFlame;

- (void) initActions;

/** Show the rocket's default state */
- (void) showFlying;

/** Show the rocket's shaking state for takeoff */
- (void) showShaking;

/** The finishing portion of the shaking animation, repeats forever */
- (void) showRepeatableShaking;

/** Show the rocket burning */
- (void) showBurning;

- (void) showSlow;

- (void) showHeart;

- (void) showAuraForDuration:(CGFloat)duration;

- (void) doneHeartAnimation;

- (void) doneHeartSequence;

- (void) showWobbling;

- (void) showVictoryBoost;

- (void) showLosingFall;

/** Only used to turn the boost on/engine off or the boost off/engine on */
- (void) toggleBoostOn:(BOOL)on;

/** Ensures the boost and engine to be off */
- (void) turnFlameOff;

@end
