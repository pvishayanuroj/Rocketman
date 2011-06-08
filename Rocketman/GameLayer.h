//
//  GameLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "CDAudioManager.h"
#import "PButtonDelegate.h"

@class Rocket;
@class Cat;
@class Boost;
@class Fuel;
@class Obstacle;
@class CDAudioManager;
@class CDSoundEngine;

@interface GameLayer : CCLayer <UIAccelerometerDelegate, PButtonDelegate> {
 
    Rocket *rocket_;
 
    NSMutableArray *obstacles_;
    
    NSMutableArray *firedCats_;
    
    NSUInteger maxObstacles_;
    
    NSUInteger maxClouds_;
    
    CGFloat rocketInitSpeed_;
    
    CGFloat rocketSpeed_;
    
    NSMutableArray *doodads_;
    
    NSMutableArray *backgroundClouds_;    
    
    NSInteger screenWidth_;
    
    NSInteger screenHeight_;
    
    NSUInteger numBoosts_;
    
    NSUInteger numCats_;
    
    CGFloat yCutoff_;
    
    NSInteger leftCutoff_;
    
    NSInteger rightCutoff_;
    
	CCParticleSystem *engineFlame_;    
    
	CCParticleSystem *boostFlame_;        

    CGFloat maxSideMoveSpeed_;
    
    CGFloat sideMoveSpeed_;
    
    float accel[3];     
    
    BOOL boostEngaged_;
    
    BOOL onGround_;
    
    BOOL inputLocked_;
    
    CGFloat height_;
    
    CGFloat maxHeight_;
    
    CGFloat lossHeight_;
    
    CGFloat nextCloudHeight_;
    
    CGFloat nextSlowCloudHeight_;
    
    CGFloat nextObstacleHeight_;
    
    CGFloat obstableFrequency_;
    
    CGFloat nextRingHeight_;

    CGFloat ringFrequency_;    
    
    CGFloat nextCatHeight_;

    CGFloat catFrequency_;    
    
    CGFloat nextFuelHeight_;
    
    CGFloat fuelFrequency_;    
    
    CCLabelTTF *heightLabel_;
    
    CCLabelTTF *speedLabel_;   
    
    CCLabelTTF *tiltLabel_;
    
    CCLabelTTF *numCatsLabel_;
    
    CCLabelTTF *numBoostsLabel_;    
    
    CGFloat v0_;    
    
    CGFloat v_;
    
    CGFloat dv_;
    
    CGFloat ddv_;
    
    CGFloat vMax_;
    
    CGFloat vBoost_;
    
    CGFloat vBoostRing_;
    
    CGFloat boost_;    
    
    CGFloat boostRate_;
    
    CGFloat boostTarget_;
    
    CGFloat boostTimer_;
    
    ALuint engineSoundID_;
    
    CDSoundSource *engineSound_;
    
    CGFloat dt_;
}

- (void) cloudGenerator;

- (void) obstacleGenerator;

- (void) physicsStep:(ccTime)dt;

- (void) applyBoost:(ccTime)dt;

- (void) applyGravity;

- (void) updateCounters;

- (void) collisionDetect;

- (void) moveRocketHorizontally;

- (NSInteger) getRandomX;

- (NSInteger) getRandomY:(CGFloat)freq;

- (void) updateFlame;

- (void) loss;

- (void) startEngineFlame;

- (void) toggleBoostFlame:(BOOL)on;

- (void) rocketBurn;

- (void) fireCat;

- (void) takeOffComplete;

- (void) useBoost;

- (void) engageBoost:(CGFloat)speedup amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time;

- (void) slowDown:(CGFloat)factor;

- (void) collectCat:(Cat *)cat;

- (void) collectFuel:(Fuel *)fuel;

- (void) collectBoost:(Boost *)boost;

- (void) showText:(EventText)event;

- (void) removeText:(id)node data:(CCSprite *)text;

- (void) playSound:(SoundType)type;

- (void) stopSound:(SoundType)type;

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

- (BOOL) intersects:(CGPoint)circle radius:(CGFloat)r rect:(CGRect)rect;

- (BOOL) intersects:(CGRect)a b:(CGRect)b;

- (void) removeObstacle:(Obstacle *)obstacle;

@end
