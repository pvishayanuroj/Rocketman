//
//  Rocket.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface Rocket : CCNode {
    
    CCSprite *sprite_;
 
    CCSprite *aura_;
    
    CCAction *flyingAnimation_;
    
    CCAction *burningAnimation_;
    
    CCAction *shakingAnimation_;    
    
    CCAction *wobblingAnimation_;
    
    CCAction *heartAnimation_;
    
    CCAction *auraAnimation_;    
    
    BOOL isBurning_;
    
    BOOL isWobbling_;
    
    BOOL isHeart_;
    
    CGRect rect_;
    
	CCParticleSystem *engineFlame_;    
    
	CCParticleSystem *boostFlame_;         
    
	CCParticleSystem *heartParticles_;
}

@property (nonatomic, readonly) CGRect rect;

+ (id) rocketWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initEngineFlame;

- (void) initActions;

- (void) showFlying;

- (void) showShaking;

- (void) showBurning;

- (void) showHeart;

- (void) showAuraForDuration:(CGFloat)duration;

- (void) doneHeartAnimation;

- (void) doneHeartSequence;

- (void) doneBurning;

- (void) showWobbling;

- (void) doneWobbling;

- (void) toggleBoostOn:(BOOL)on;

- (void) turnFlameOff;

@end
