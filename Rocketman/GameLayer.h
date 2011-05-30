//
//  GameLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "PButtonDelegate.h"

@class Rocket;
@class Cat;
@class Boost;
@class Fuel;
@class Obstacle;

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
    
    BOOL leftPressed_;
    
    BOOL rightPressed_;
    
    NSUInteger pressedTime_;
    
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
    
    CCLabelAtlas *heightLabel_;
    
    CCLabelAtlas *speedLabel_;    
    
    CGFloat v0_;    
    
    CGFloat v_;
    
    CGFloat dv_;
    
    CGFloat vMax_;
    
    CGFloat vBoost_;
    
    CGFloat vBoostRing_;
    
    CGFloat boost_;    
    
    CGFloat boostRate_;
    
    CGFloat boostTarget_;
}

- (void) cloudGenerator;

- (void) obstacleGenerator;

- (void) physicsStep;

- (void) applyGravity;

- (void) updateCounters;

- (void) collisionDetect;

- (void) moveRocketHorizontally;

- (void) updateFlame;

- (void) startEngineFlame;

- (void) toggleBoostFlame:(BOOL)on;

- (void) rocketBurn;

- (void) fireCat;

- (void) takeOffComplete;

- (void) useBoost;

- (void) engageBoost:(CGFloat)speedup amt:(CGFloat)amt rate:(CGFloat)rate;

- (void) collectCat:(Cat *)cat;

- (void) collectFuel:(Fuel *)fuel;

- (void) collectBoost:(Boost *)boost;

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

- (void) removeObstacle:(Obstacle *)obstacle;

@end
