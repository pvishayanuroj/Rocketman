//
//  GameLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "CDAudioManager.h"

@class Rocket;
@class Cat;
@class Boost;
@class Fuel;
@class Obstacle;
@class CDAudioManager;
@class CDSoundEngine;

@interface GameLayer : CCLayer <UIAccelerometerDelegate> {
 
    Rocket *rocket_;
    
    BOOL test;
 
    NSMutableArray *obstacles_;
    
    NSMutableArray *firedCats_;
    
    NSUInteger maxObstacles_;
    
    NSUInteger maxClouds_;
    
    CGFloat rocketInitSpeed_;
    
    CGFloat rocketSpeed_;
    
    NSMutableArray *doodads_;
    
    NSInteger screenWidth_;
    
    NSInteger screenHeight_;
    
    NSUInteger numBoosts_;
    
    NSUInteger numCats01_;
    
    NSUInteger numCats02_;
    
    CGFloat yCutoff_;
    
    NSInteger leftCutoff_;
    
    NSInteger rightCutoff_;

    CGFloat maxSideMoveSpeed_;
    
    CGFloat sideMoveSpeed_;
    
    CGFloat targetX_;
    
    CGFloat avg_[2];
    
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
    
    CGFloat dt_;
    
    // Temp variables for debugging
    BOOL bossAdded_;
    
    NSInteger ammoType_;
}

+ (id) startWithLevel:(NSUInteger)levelNum;

- (id) initWithLevel:(NSUInteger)levelNum;

- (void) cloudGenerator;

- (void) bossGenerator;

- (void) obstacleGenerator;

- (void) physicsStep:(ccTime)dt;

- (void) applyBoost:(ccTime)dt;

- (void) applyGravity;

- (void) updateCounters;

- (void) collisionDetect;

- (void) moveRocketHorizontally;

- (NSInteger) getRandomX;

- (NSInteger) getRandomY:(CGFloat)freq;

- (void) loss;

- (void) addTurtlingSwarm:(NSInteger)size;

- (void) addObstacle:(ObstacleType)type pos:(CGPoint)pos;

- (void) fireCat01;

- (void) fireCat02;

- (void) takeOffComplete;

- (void) setRocketCondition:(RocketCondition)condition;

- (void) useBoost;

- (void) engageBoost:(CGFloat)speedup amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time;

- (void) engageFixedBoost:(CGFloat)speed amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time;

- (void) slowDown:(CGFloat)factor;

- (void) collectCat:(Cat *)cat;

- (void) collectFuel:(Fuel *)fuel;

- (void) collectBoost:(Boost *)boost;

- (void) showText:(EventText)event;

- (void) removeText:(id)node data:(CCSprite *)text;

@end
