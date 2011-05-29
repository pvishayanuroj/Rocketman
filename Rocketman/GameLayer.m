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
#import "Cat.h"
#import "CatBullet.h"
#import "EngineParticleSystem.h"

@implementation GameLayer

/**
 Game layer initialization method
 @returns Returns the created game layer
 */
- (id) init
{
	if ((self = [super init])) {

        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        
        screenWidth_ = size.width;
        screenHeight_ = size.height;        
        
        yCutoff_ = -(screenHeight_ + 100);
        leftCutoff_ = SIDE_MARGIN;
        rightCutoff_ = screenWidth_ - SIDE_MARGIN;
        
        // Add background
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:bg z:kBackgroundDepth];
        bg.anchorPoint = CGPointZero;
        
        // Add the rocket
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.5);
        rocket_ = [Rocket rocketWithPos:startPos];
        [self addChild:rocket_ z:kRocketDepth];
        
        // DEBUG
        [rocket_ showFlying];
        [self startEngineFlame];
        
        obstacles_ = [[NSMutableArray arrayWithCapacity:20] retain];
        firedCats_ = [[NSMutableArray arrayWithCapacity:5] retain];
        doodads_ = [[NSMutableArray arrayWithCapacity:20] retain];
        
        rocketInitSpeed_ = 5.0;
        rocketSpeed_ = 4;
        numCats_ = 0;
        numBoosts_ = 0;
        
        sideMoveSpeed_ = 0;
        leftPressed_ = NO;
        rightPressed_ = NO;
        pressedTime_ = 0;
        maxSideMoveSpeed_ = 8;
        temp = NO;
        
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
    [engineFlame_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    [self applyGravity];
    [self moveRocketHorizontally];
    [self collisionDetect];        
}

- (void) slowUpdate:(ccTime)dt
{
    [self cloudGenerator];
    [self obstacleGenerator];    
}

- (void) collisionDetect
{
    CGFloat distance;
    CGFloat threshold;
    
    // For checking if the rocket collides with obstacles
    for (Obstacle *obstacle in obstacles_) {
        
        if (obstacle.collided) {
            continue;
        }
        
        distance = [self distanceNoRoot:rocket_.position b:obstacle.position];
        
        //NSLog(@"distance: %3.2f, radius: %3.2f", distance, obstacle.radiusSquared);
        
        if (distance < obstacle.radiusSquared) {
            [obstacle collide];
        }   
    }
    
    // For checking cat collisions with obstacles
    for (CatBullet *cat in firedCats_) {
        for (Obstacle *obstacle in obstacles_) {
            
            if (!obstacle.shootable) {
                continue;
            }
            
            distance = [self distanceNoRoot:cat.position b:obstacle.position];
            threshold = cat.radius + obstacle.radius;
            
            if (distance < (threshold * threshold)) {
                [obstacle bulletHit];
                
                [cat removeFromParentAndCleanup:YES];
                [firedCats_ removeObject:cat];
                
                [obstacle removeFromParentAndCleanup:YES];
                [obstacles_ removeObject:obstacle];
                
                // Get out of inner loop
                break; 
            }
            
        }
    }
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
    
    for (CatBullet *cat in firedCats_) {
        [cat fall:rocketSpeed_];
        
        if (cat.position.y > screenHeight_) {
            [cat removeFromParentAndCleanup:YES];
            [firedCats_ removeObject:cat];
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
        NSInteger z;
        NSUInteger type = arc4random() % 3;
        NSInteger xCoord = arc4random() % screenWidth_;
        
        // DEBUG
        //type = 0;
        //xCoord = screenWidth_ / 2;
        
        CGPoint pos = CGPointMake(xCoord, screenHeight_);
        
        switch (type) {
            case 0:
                obstacle = [Dino dinoWithPos:pos];
                z = kObstacleDepth;
                break;
            case 1:
                obstacle = [Alien alienWithPos:pos];
                z = kObstacleDepth;
                break;
            case 2:
                obstacle = [Cat catWithPos:pos];
                z = kCatDepth;
                break;
            default:
                NSAssert(NO, @"Invalid obstacle number selected");
                break;
        }
        
        [self addChild:obstacle z:z];
        [obstacles_ addObject:obstacle];
        
    }
}

- (void) moveRocketHorizontally
{
    CGPoint pos;
    CGFloat dx = 0;
    
#if DEBUG_MOVEBUTTONS
    NSUInteger base = 7;
    CGFloat modifier;    
    
    if (rightPressed_ || leftPressed_) {
        modifier = 1.00 + pressedTime_ * 0.01;
        dx = base * modifier;

        dx = leftPressed_ ? -dx : dx;    
    }
#else
    dx = sideMoveSpeed_;
#endif
    
    CGPoint moveAmt = CGPointMake(dx, 0);
    pos = ccpAdd(rocket_.position, moveAmt);
    if (pos.x > leftCutoff_ && pos.x < rightCutoff_) {
        rocket_.position = pos;
        engineFlame_.position = ccpAdd(engineFlame_.position, moveAmt);            
    }
}

- (void) startEngineFlame
{
	engineFlame_ = [[EngineParticleSystem engineParticleSystem:300] retain];
	[self addChild:engineFlame_ z:kRocketFlameDepth];
    
    engineFlame_.gravity = ccp(0, -100);
    ccColor4B orange = ccc4(255, 165, 0, 255);
    ccColor4F c1 = ccc4FFromccc4B(orange);
    ccColor4F c2 = c1;
    c2.a = 0;
    engineFlame_.startColor = c1;
    engineFlame_.endColor = c2;
    
    
    engineFlame_.startSize = 10.0f;
    engineFlame_.startSizeVar = 5.0f;
    engineFlame_.endSize = kCCParticleStartSizeEqualToEndSize;    
    
    // life of particles
    engineFlame_.life = 0.5;
    engineFlame_.lifeVar = 0.25f;
    
    // emits per seconds
    engineFlame_.emissionRate = engineFlame_.totalParticles/engineFlame_.life;
    
	engineFlame_.position = CGPointMake(rocket_.position.x, rocket_.position.y - 30);;
}

- (void) rocketBurn
{
    [rocket_ showBurning];
}

- (void) fireCat
{
    CatBullet *bullet = [CatBullet catBulletWithPos:rocket_.position withSpeed:10];
    [self addChild:bullet z:kBulletDepth];
    [firedCats_ addObject:bullet];
}

- (void) useBoost
{
    
}

- (void) collectBoost
{
    
}

- (void) collectCat:(Cat *)cat
{
    numCats_++;
    
    [obstacles_ removeObject:cat];
}

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return t1*t1 + t2*t2;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //ramp-speed - play with this value until satisfied
    const float kFilteringFactor = 0.1f;
    
    //last result storage - keep definition outside of this function, eg. in wrapping object

    
    //acceleration.x,.y,.z is the input from the sensor
    
    //result.x,.y,.z is the filtered result
    
    //high-pass filter to eleminate gravity
    accel[0] = acceleration.x * kFilteringFactor + accel[0] * (1.0f - kFilteringFactor);
    //accel[1] = acceleration.y * kFilteringFactor + accel[1] * (1.0f - kFilteringFactor);
    //accel[2] = acceleration.z * kFilteringFactor + accel[2] * (1.0f - kFilteringFactor);
    CGFloat resultx = acceleration.x - accel[0];
    //CGFloat resulty = acceleration.y - accel[1];
    //CGFloat resultz = acceleration.z - accel[2];    

    CGFloat ddx;
    ddx = resultx > 0.5 ? 0.5 : resultx;
    ddx = resultx < 0.5 ? -0.5 : resultx;    
    
    if (resultx < 0.03 && resultx > -0.03) {
        ddx = 0;
    }
    else if (ddx < 0) {
        ddx += 0.03;
        ddx /= 0.47;
        ddx *= 2;
    }
    else if (ddx > 0) {
        ddx -= 0.03;
        ddx /= 0.47;
        ddx *= 2;
    }
    
    
    //NSLog(@"x accel: %4.2f, speed: %4.2f", resultx, ddx);        
    sideMoveSpeed_ = resultx*17;    

}

- (void) leftButtonPressed
{
    leftPressed_ = YES;
    pressedTime_ = 0;    
}

- (void) rightButtonPressed
{
    rightPressed_ = YES;
    pressedTime_ = 0;    
}

- (void) leftButtonDepressed
{
    leftPressed_ = NO;        
}

- (void) rightButtonDepressed
{
    rightPressed_ = NO;        
}

@end
