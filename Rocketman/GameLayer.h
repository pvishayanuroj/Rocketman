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

@interface GameLayer : CCLayer <UIAccelerometerDelegate, PButtonDelegate> {
 
    Rocket *rocket_;
 
    NSMutableArray *obstacles_;
    
    NSMutableArray *firedCats_;
    
    NSUInteger maxObstacles_;
    
    NSUInteger maxClouds_;
    
    CGFloat rocketInitSpeed_;
    
    CGFloat rocketSpeed_;
    
    CGFloat rocketAcceleration_;
    
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
    
    CGFloat height_;
    
    CGFloat maxHeight_;
    
    CGFloat nextCloudHeight_;
    
    CGFloat nextSlowCloudHeight_;
    
    CCLabelAtlas *heightLabel_;
    
    CCLabelAtlas *speedLabel_;    
    
    CGFloat dt_;
    
    CGFloat dx_;
    
    CGFloat x0_;
    
    CGFloat v0_;    
    
    CGFloat xn_;
    
    CGFloat v_, dv_;
    
    CGFloat a_;
    
    CGFloat g_;
    
    CGFloat boostRate_;
    
    CGFloat boostAmt_;
    
    CGFloat boostTarget_;
}

- (void) cloudGenerator;

- (void) obstacleGenerator;

- (void) applyGravity;

- (void) collisionDetect;

- (void) moveRocketHorizontally;

- (void) startEngineFlame;

- (void) toggleBoostFlame:(BOOL)on;

- (void) rocketBurn;

- (void) fireCat;

- (void) useBoost;

- (void) collectCat:(Cat *)cat;

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

@end
