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
        
        // Add the rocket
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.8);
        rocket_ = [Rocket rocketWithPos:startPos];
        [self addChild:rocket_];
        
        obstacles_ = [[NSMutableArray arrayWithCapacity:20] retain];
        firedCats_ = [[NSMutableArray arrayWithCapacity:5] retain];
        clouds_ = [[NSMutableArray arrayWithCapacity:20] retain];
        
        rocketInitSpeed_ = 5.0;
        rocketSpeed_ = 0;
        
        [self schedule:@selector(update:) interval:1.0/60.0];
        
	}
	return self;
}

- (void) dealloc
{
    [rocket_ release];
    [obstacles_ release];
    [firedCats_ release];
    [clouds_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    [self cloudGenerator];
    [self obstacleGenerator];
    [self applyGravity];
    [self collisionDetect];        
    
    /*
    CGFloat random = arc4random() % 1000;
    
    if (random < 30) {
        CCSprite *cloud = [CCSprite spriteWithFile:@"cloud.png"];
        CGFloat x = arc4random() % screenWidth_;
        cloud.position = CGPointMake(x, screenHeight_);
        [self addChild:cloud];
        [clouds_ addObject:cloud];        
    }
    
    for (CCSprite *c in clouds_) {
        CGPoint p = CGPointMake(0, speed_);
        c.position = ccpSub(c.position, p);
        
        if (c.position.y > screenHeight_ + 100) {
            [c removeFromParentAndCleanup:YES];
            [clouds_ removeObject:c];
        }
    }
    */
}

- (void) collisionDetect
{
    
}

- (void) applyGravity
{
    for (CCSprite *c in clouds_) {
        CGPoint p = CGPointMake(0, rocketSpeed_);
        c.position = ccpSub(c.position, p);
        
        if (c.position.y > screenHeight_ + 100) {
            [c removeFromParentAndCleanup:YES];
            [clouds_ removeObject:c];
        }
    }    
    
    for (Obstacle *obstacle in obstacles_) {
        [obstacle fall:rocketSpeed_];
        
        if (obstacle.position.y > screenHeight_ + 100) {
            [obstacle removeFromParentAndCleanup:YES];
            [obstacles_ removeObject:obstacle];
        }
    }    
}

- (void) cloudGenerator
{
    
}

- (void) obstacleGenerator
{
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
    
    [self addChild:obstacle];
    [obstacles_ addObject:obstacle];
}





@end
