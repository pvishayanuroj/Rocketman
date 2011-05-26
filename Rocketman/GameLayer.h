//
//  GameLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Rocket;

@interface GameLayer : CCLayer {
 
    Rocket *rocket_;
 
    NSMutableArray *obstacles_;
    
    NSMutableArray *firedCats_;
    
    NSUInteger maxObstacles_;
    
    NSUInteger maxClouds_;
    
    CGFloat rocketInitSpeed_;
    
    CGFloat rocketSpeed_;
    
    NSMutableArray *clouds_;
    
    NSMutableArray *backgroundClouds_;    
    
    NSUInteger screenWidth_;
    NSUInteger screenHeight_;
    
    NSUInteger numBoosts_;
    
    NSUInteger numCats_;
    
}

- (void) cloudGenerator;

- (void) obstacleGenerator;

- (void) applyGravity;

- (void) collisionDetect;


@end
