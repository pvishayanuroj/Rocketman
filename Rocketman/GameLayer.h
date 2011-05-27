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

@interface GameLayer : CCLayer <PButtonDelegate> {
 
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
    
    NSInteger yCutoff_;
    
	CCParticleSystem *engineFlame_;    
    
    BOOL leftPressed_;
    
    BOOL rightPressed_;
    
    NSUInteger pressedTime_;
    
    CGFloat maxSideMoveSpeed_;
    
    BOOL temp;
}

- (void) cloudGenerator;

- (void) obstacleGenerator;

- (void) applyGravity;

- (void) collisionDetect;

- (void) moveRocketHorizontally;

- (void) startEngineFlame;

- (void) rocketBurn;

- (void) fireCat;

- (void) useBoost;

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

@end
