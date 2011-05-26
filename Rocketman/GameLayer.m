//
//  GameLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "Rocket.h"
#import "Obstacle.h"
#import "Doodad.h"
#import "Cloud.h"
#import "Alien.h"
#import "Dino.h"

@implementation GameLayer

/**
 Game layer initialization method
 @returns Returns the created game layer
 */
- (id) init
{
	if ((self = [super init])) {

		CGSize size = [[CCDirector sharedDirector] winSize];        
        
        screenWidth_ = size.width;
        screenHeight_ = size.height;        
        
        yCutoff_ = -(screenHeight_ + 100);
        
        // Add background
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:bg z:kBackgroundDepth];
        bg.anchorPoint = CGPointZero;
        
        // Add the rocket
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.2);
        rocket_ = [Rocket rocketWithPos:startPos];
        [self addChild:rocket_ z:kRocketDepth];
        
        obstacles_ = [[NSMutableArray arrayWithCapacity:20] retain];
        firedCats_ = [[NSMutableArray arrayWithCapacity:5] retain];
        doodads_ = [[NSMutableArray arrayWithCapacity:20] retain];
        
        rocketInitSpeed_ = 5.0;
        rocketSpeed_ = 4;
        
        [self schedule:@selector(update:) interval:1.0/60.0];
        [self schedule:@selector(slowUpdate:) interval:60.0/60.0];
        
	}
	return self;
}

- (void) dealloc
{
    [rocket_ release];
    [obstacles_ release];
    [firedCats_ release];
    [doodads_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    [self applyGravity];
    [self collisionDetect];        
}

- (void) slowUpdate:(ccTime)dt
{
    NSLog(@"doodads: %d", [doodads_ count]);
    NSLog(@"obstacles: %d", [obstacles_ count]);    
    
    [self cloudGenerator];
    [self obstacleGenerator];    
}

- (void) collisionDetect
{
    
}

- (void) applyGravity
{
    for (Doodad *doodad in doodads_) {
        [doodad fall:rocketSpeed_];

        if (doodad.position.y < yCutoff_) {
            [doodad removeFromParentAndCleanup:YES];
            [doodads_ removeObject:doodad];
        }
    }    
    
    for (Obstacle *obstacle in obstacles_) {
        [obstacle fall:rocketSpeed_];
        
        if (obstacle.position.y < yCutoff_) {
            [obstacle removeFromParentAndCleanup:YES];
            [obstacles_ removeObject:obstacle];
        }
    }    
}

- (void) cloudGenerator
{
    NSUInteger chance = 35;
    NSUInteger randNum = arc4random() % 100;
    
    if (randNum < chance) {    
        
        NSInteger xCoord = arc4random() % screenWidth_;
        
        CGPoint pos = CGPointMake(xCoord, screenHeight_);        
        Doodad *doodad = [Cloud cloudWithPos:pos];
        
        [self addChild:doodad z:kCloudDepth];   
        [doodads_ addObject:doodad];
    }
}

- (void) obstacleGenerator
{
    NSUInteger chance = 50;
    NSUInteger randNum = arc4random() % 100;
    
    if (randNum < chance) {
    
        Obstacle *obstacle;
        NSUInteger type = arc4random() % 2;
        NSInteger xCoord = arc4random() % screenWidth_;
        
        CGPoint pos = CGPointMake(xCoord, screenHeight_);
        
        switch (type) {
            case 0:
                obstacle = [Dino dinoWithPos:pos];
                break;
            case 1:
                obstacle = [Alien alienWithPos:pos];
                break;
            default:
                NSAssert(NO, @"Invalid obstacle number selected");
                break;
        }
        
        [self addChild:obstacle z:kObstacleDepth];
        [obstacles_ addObject:obstacle];
        
    }
}





@end
