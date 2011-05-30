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
#import "SlowCloud.h"
#import "Alien.h"
#import "Dino.h"
#import "Cat.h"
#import "CatBullet.h"
#import "Fuel.h"
#import "Boost.h"
#import "EngineParticleSystem.h"

@implementation GameLayer

- (id) init
{
	if ((self = [super init])) {

        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        
        screenWidth_ = size.width;
        screenHeight_ = size.height;        
        
        yCutoff_ = -screenHeight_*3;
        leftCutoff_ = SIDE_MARGIN;
        rightCutoff_ = screenWidth_ - SIDE_MARGIN;
        
        // Add background
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:bg z:kBackgroundDepth];
        bg.anchorPoint = CGPointZero;
        
        // Add the rocket
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.3);
        rocket_ = [Rocket rocketWithPos:startPos];
        [self addChild:rocket_ z:kRocketDepth];
        
        // DEBUG
        [rocket_ showFlying];
        [self startEngineFlame];
        
        obstacles_ = [[NSMutableArray arrayWithCapacity:20] retain];
        firedCats_ = [[NSMutableArray arrayWithCapacity:5] retain];
        doodads_ = [[NSMutableArray arrayWithCapacity:20] retain];
        
        rocketInitSpeed_ = 5.0;
        rocketSpeed_ = 10;
        rocketAcceleration_ = 1;
        numCats_ = 0;
        numBoosts_ = 0;
        height_ = 0;
        maxHeight_ = 0;
        nextCloudHeight_ = 0;
        nextSlowCloudHeight_ = 0;
        nextObstacleHeight_ = 0;
        
        sideMoveSpeed_ = 0;
        leftPressed_ = NO;
        rightPressed_ = NO;
        pressedTime_ = 0;
        maxSideMoveSpeed_ = 8;
        boostEngaged_ = NO;
        
        v_ = 8;
        dv_ = 0;
        vMax_ = 14;
        
		heightLabel_ = [[CCLabelAtlas labelWithString:@"00.0" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];         
        heightLabel_.position =  ccp(0, screenHeight_*0.95);
		[self addChild:heightLabel_];        
		speedLabel_ = [[CCLabelAtlas labelWithString:@"00.0" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];         
        speedLabel_.position =  ccp(0, screenHeight_*0.9);
		[self addChild:speedLabel_];                
        
        [self schedule:@selector(update:) interval:1.0/60.0];
        [self schedule:@selector(slowUpdate:) interval:10.0/60.0];    
        
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
    [heightLabel_ release];
    [speedLabel_ release];    
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{    
    [self physicsStep];
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

- (void) physicsStep
{
    v_ += dv_;
    rocketSpeed_ = v_;
    
    dv_ -= 0.00005;
    
    if (boostEngaged_) {
        if (v_ > boostTarget_ || v_ > vMax_) {
            boostEngaged_ = NO;
            [self toggleBoostFlame:NO];            
        }
        else {
            v_ += boostRate_;
            boostRate_ += 0.01;
        }
    }    
    
    if (rocketSpeed_ < 0) {
        engineFlame_.emissionRate = 0;
    }
    
    // Keep track of height
    height_ += rocketSpeed_;
    if (height_ > maxHeight_) {
        maxHeight_ = height_;
    }
    
    [heightLabel_ setString:[NSString stringWithFormat:@"%7.0f", height_]];
    [speedLabel_ setString:[NSString stringWithFormat:@"%6.1f", rocketSpeed_]];        
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
    if (height_ > nextCloudHeight_) {
        
        nextCloudHeight_ += 100;
        
        NSInteger xCoord = arc4random() % screenWidth_;
        NSInteger yCoord = screenHeight_ + arc4random() % screenHeight_;
        
        CGPoint pos = CGPointMake(xCoord, screenHeight_ + yCoord);        
        Doodad *doodad = [Cloud cloudWithPos:pos];
        
        [self addChild:doodad z:kCloudDepth];   
        [doodads_ addObject:doodad];        
        
    }
    
    if (height_ > nextSlowCloudHeight_) {
        nextSlowCloudHeight_ += 1500;
        
        NSInteger xCoord = arc4random() % screenWidth_;
        NSInteger yCoord = screenHeight_ + arc4random() % screenHeight_;
        
        CGPoint pos = CGPointMake(xCoord, screenHeight_ + yCoord);        
        Doodad *doodad = [SlowCloud slowCloudWithPos:pos];
        
        [self addChild:doodad z:kCloudDepth];   
        [doodads_ addObject:doodad];        
        
    }    
}

- (void) obstacleGenerator
{
    if (height_ > nextObstacleHeight_) {
        nextObstacleHeight_ += 400;
        
        Obstacle *obstacle;
        
        NSInteger xCoord = arc4random() % screenWidth_;   
        //NSInteger yCoord = screenHeight_ + arc4random() % screenHeight_;        
        NSInteger yCoord = screenHeight_ + 100;
        CGPoint pos = CGPointMake(xCoord, screenHeight_ + yCoord);                
        
        NSInteger z;
        NSUInteger type = arc4random() % 4;
        
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
            case 3:
                obstacle = [Boost boostWithPos:pos];
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
        boostFlame_.position = engineFlame_.position;
    }
}

- (void) startEngineFlame
{
	engineFlame_ = [[EngineParticleSystem engineParticleSystem:300] retain];
	[self addChild:engineFlame_ z:kRocketFlameDepth];
    
	boostFlame_ = [[EngineParticleSystem engineParticleSystem:700] retain];
	[self addChild:boostFlame_ z:kRocketFlameDepth];    
    
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
    
	engineFlame_.position = CGPointMake(rocket_.position.x, rocket_.position.y - 30);
    
    
    // BOOST
    boostFlame_.gravity = ccp(0, -300);
    ccColor4B purple = ccc4(255, 20, 147, 255);
    c1 = ccc4FFromccc4B(purple);
    c2 = c1;
    c2.a = 0;
    boostFlame_.startColor = c1;
    boostFlame_.endColor = c2;
    
    
    boostFlame_.startSize = 20.0f;
    boostFlame_.startSizeVar = 5.0f;
    boostFlame_.endSize = kCCParticleStartSizeEqualToEndSize;    
    
    // life of particles
    boostFlame_.life = 0.5;
    boostFlame_.lifeVar = 0.25f;
    
    // emits per seconds
    //boostFlame_.emissionRate = boostFlame_.totalParticles/boostFlame_.life;
    boostFlame_.emissionRate = 0;
    
	boostFlame_.position = CGPointMake(rocket_.position.x, rocket_.position.y - 30);    
}

- (void) toggleBoostFlame:(BOOL)on
{
    if (on) {
        engineFlame_.emissionRate = 0;
        boostFlame_.emissionRate = boostFlame_.totalParticles/boostFlame_.life;
    }
    else {
        boostFlame_.emissionRate = 0;
        engineFlame_.emissionRate = engineFlame_.totalParticles/engineFlame_.life;        
    }
}

- (void) rocketBurn
{
    [rocket_ showBurning];
}

- (void) fireCat
{
    CatBullet *bullet = [CatBullet catBulletWithPos:rocket_.position withSpeed:(rocketSpeed_ + 10)];
    [self addChild:bullet z:kBulletDepth];
    [firedCats_ addObject:bullet];
}

- (void) useBoost
{
    numBoosts_--;
    [self engageBoost];
}

- (void) engageBoost
{
    dv_ = 0;
    
    boostEngaged_ = YES;
    if (v_ < 0) {
        boostTarget_ = 10;
        boostRate_ = 0.1;
    }
    else {
        boostTarget_ = v_ + 5;
        boostRate_ = 0.1;
    }
    
    [self toggleBoostFlame:YES];    
}

- (void) collectBoost:(Boost *)boost
{
    [obstacles_ removeObject:boost];
    [self engageBoost];    
}

- (void) collectFuel:(Fuel *)fuel
{
    numBoosts_++;
    [obstacles_ removeObject:fuel];
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
      
    sideMoveSpeed_ = resultx*25;    

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
