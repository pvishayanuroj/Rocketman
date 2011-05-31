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
#import "Ground.h"
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
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.15);
        rocket_ = [Rocket rocketWithPos:startPos];
        [self addChild:rocket_ z:kRocketDepth];
        
        [self startEngineFlame];
        
        obstacles_ = [[NSMutableArray arrayWithCapacity:20] retain];
        firedCats_ = [[NSMutableArray arrayWithCapacity:5] retain];
        doodads_ = [[NSMutableArray arrayWithCapacity:20] retain];
        
        rocketSpeed_ = 0;
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
        onGround_ = YES;
        inputLocked_ = NO;
        
        v_ = 0;
        v0_ = 8;
        vBoost_ = 5;
        vBoostRing_ = 4; 
        dv_ = 0;
        vMax_ = 12;
        
        // Add ground 
        Doodad *ground = [Ground groundWithPos:CGPointMake(0, 0)];
        [self addChild:ground];
        [doodads_ addObject:ground];        
        
        // Add stats
		heightLabel_ = [[CCLabelTTF labelWithString:@"00.0" fontName:@"Courier" fontSize:16] retain];
        heightLabel_.position =  ccp(50, screenHeight_*0.95);
        heightLabel_.color = ccc3(0, 0, 0);
		[self addChild:heightLabel_ z:kLabelDepth];        
		speedLabel_ = [[CCLabelTTF labelWithString:@"00.0" fontName:@"Courier" fontSize:16] retain];
        speedLabel_.position =  ccp(50, screenHeight_*0.9);
        speedLabel_.color = ccc3(0, 0, 0);        
		[self addChild:speedLabel_ z:kLabelDepth];           
		tiltLabel_ = [[CCLabelTTF labelWithString:@"00.0" fontName:@"Courier" fontSize:16] retain];
        tiltLabel_.position =  ccp(50, screenHeight_*0.85);
        tiltLabel_.color = ccc3(0, 0, 0);        
		[self addChild:tiltLabel_ z:kLabelDepth];                   
        
        // Button counters
        numCatsLabel_ = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", numCats_] fontName:@"Marker Felt" fontSize:48] retain];
        numBoostsLabel_ = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", numBoosts_] fontName:@"Marker Felt" fontSize:48] retain];        
        numCatsLabel_.position = ccp(130, 35);
        numBoostsLabel_.position = ccp(275, 35);        
        numCatsLabel_.color  = ccc3(0, 0, 0);
        numBoostsLabel_.color  = ccc3(0, 0, 0);        
        [self addChild:numCatsLabel_ z:kLabelDepth];
        [self addChild:numBoostsLabel_ z:kLabelDepth];        
        
        [self schedule:@selector(update:) interval:1.0/60.0];
        [self schedule:@selector(slowUpdate:) interval:10.0/60.0];    
        
	}
	return self;
}

- (void) dealloc
{
    NSLog(@"Game Layer dealloc'd");
    
    [rocket_ release];
    [obstacles_ release];
    [firedCats_ release];
    [doodads_ release];
    [engineFlame_ release];
    [boostFlame_ release];
    [heightLabel_ release];
    [speedLabel_ release];    
    [tiltLabel_ release];
    [numCatsLabel_ release];
    [numBoostsLabel_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{    
    //NSLog(@"dt: %1.3f", dt); 
#if !DEBUG_CONSTANTSPEED    
    [self physicsStep:dt];
#endif
    [self updateCounters];
    [self applyGravity];
    [self moveRocketHorizontally];
    [self updateFlame];
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
    
    NSMutableIndexSet *remove = [NSMutableIndexSet indexSet];
    NSUInteger index = 0;    
    
    // For checking cat collisions with obstacles
    for (CatBullet *cat in firedCats_) {
        for (Obstacle *obstacle in obstacles_) {
            
            if (!obstacle.shootable) {
                continue;
            }
            
            distance = [self distanceNoRoot:cat.position b:obstacle.position];
            threshold = cat.radius + obstacle.radius;
            
            // If a collision occurred, remove the cat bullet and notify the obstacle of the hit
            if (distance < (threshold * threshold)) {
                [remove addIndex:index];
                [obstacle bulletHit];
                [cat removeFromParentAndCleanup:YES];
                
                // Get out of inner loop
                break; 
            }   
        }
        index++;
    }
    
    // Remove outside the loop
    [firedCats_ removeObjectsAtIndexes:remove];
}

- (void) physicsStep:(ccTime)dt
{
    if (!onGround_) {
        
        v_ += dv_;
        
        rocketSpeed_ = v_;

        //dv_ -= (dt*0.002352941176471);
        //dv_ -= (dt*0.000002352941176);
        //dv_ -= 0.00004;
        dv_ -= 0.00002;        
        
        if (boostEngaged_) {
            if (v_ > boostTarget_ || v_ > vMax_) {
                boostEngaged_ = NO;
                [self toggleBoostFlame:NO];            
            }
            else {
                v_ += boost_;
                boost_ += boostRate_;
            }
        }    
        
        // Turn the engine off if we are falling
        if (rocketSpeed_ < 0) {
            engineFlame_.emissionRate = 0;
        }
    }
}

- (void) updateCounters
{
    // Keep track of height
    height_ += rocketSpeed_;
    if (height_ > maxHeight_) {
        maxHeight_ = height_;
        lossHeight_ = height_ - screenHeight_ * 3;
    }
    
    // Check for lose condition
    if (height_ < lossHeight_) {
        [self loss];
    }
    
    [heightLabel_ setString:[NSString stringWithFormat:@"%7.0f", height_]];
    [speedLabel_ setString:[NSString stringWithFormat:@"%6.1f", rocketSpeed_]];            
}

- (void) applyGravity
{
    NSMutableIndexSet *remove;
    NSUInteger index;
    
    // Doodads
    
    remove = [NSMutableIndexSet indexSet];
    index = 0;
    
    for (Doodad *doodad in doodads_) {
        [doodad fall:rocketSpeed_];

        // If past the cutoff boundary, delete
        if (doodad.position.y < yCutoff_) {
            [remove addIndex:index];            
            [doodad removeFromParentAndCleanup:YES];
        }
        index++;
    }    
    // Remove outside the loop
    [doodads_ removeObjectsAtIndexes:remove];
    
    // Obstacles
    
    remove = [NSMutableIndexSet indexSet];
    index = 0;    
    
    for (Obstacle *obstacle in obstacles_) {
        [obstacle fall:rocketSpeed_];
        
        // If past the cutoff boundary, delete        
        if (obstacle.position.y < yCutoff_) {
            [remove addIndex:index];
            [obstacle destroy];
        }
        index++;
    }    
    // Remove outside the loop
    [obstacles_ removeObjectsAtIndexes:remove];    
    
    // Bullets

    remove = [NSMutableIndexSet indexSet];
    index = 0;    
    
    for (CatBullet *cat in firedCats_) {
        [cat fall:rocketSpeed_];
        
        // If past the cutoff boundary, delete        
        if (cat.position.y > screenHeight_ || cat.position.y < yCutoff_) {
            [remove addIndex:index];            
            [cat removeFromParentAndCleanup:YES];
        }
        index++;
    }
    // Remove outside the loop
    [firedCats_ removeObjectsAtIndexes:remove];    
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
        nextObstacleHeight_ += 300;
        
        Obstacle *obstacle;
        
        NSInteger xCoord = arc4random() % screenWidth_;   
        //NSInteger yCoord = screenHeight_ + arc4random() % screenHeight_;        
        NSInteger yCoord = screenHeight_ + 100;
        CGPoint pos = CGPointMake(xCoord, screenHeight_ + yCoord);                
        
        NSInteger z;
        NSUInteger type = arc4random() % 4;
        //type = 1;
        
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
            case 3:
                obstacle = [Boost boostWithPos:pos];
                z = kObstacleDepth;
                break;
            default:
                NSAssert(NO, @"Invalid obstacle number selected");
                break;
        }
        
        [self addChild:obstacle z:z];
        [obstacles_ addObject:obstacle]; 
        
        //NSLog(@"added %@, rc: %d", obstacle, [obstacle retainCount]);
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
    if (pos.x > leftCutoff_ && pos.x < rightCutoff_ && !onGround_ && !inputLocked_) {
        rocket_.position = pos;
    }
}

- (void) updateFlame
{
    engineFlame_.position = CGPointMake(rocket_.position.x, rocket_.position.y - 30);
    boostFlame_.position = engineFlame_.position;        
}

- (void) loss
{
    onGround_ = YES;
    rocketSpeed_ = 0;
    
    CCFiniteTimeAction *fall = [CCMoveBy actionWithDuration:0.2 position:CGPointMake(0, -300)];
    [rocket_ runAction:fall];
}

- (void) clearStage
{
    
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
    engineFlame_.emissionRate = 0;
    
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
    if (!onGround_ && !inputLocked_) {        
#if !DEBUG_UNLIMTED_CATS        
        if (numCats_ > 0) {
#endif
            numCats_--;
            [numCatsLabel_ setString:[NSString stringWithFormat:@"%d", numCats_]];            
            
            CatBullet *bullet = [CatBullet catBulletWithPos:rocket_.position withSpeed:(rocketSpeed_ + 10)];
            [self addChild:bullet z:kBulletDepth];
            [firedCats_ addObject:bullet];
#if !DEBUG_UNLIMTED_CATS
        }
#endif
    }
}

- (void) takeOffComplete
{
    inputLocked_ = NO;
    [rocket_ realignSprite];
    [rocket_ showFlying];
}

- (void) engageBoost:(CGFloat)speedup amt:(CGFloat)amt rate:(CGFloat)rate
{
    dv_ = 0;
    
    boostEngaged_ = YES;
    if (v_ < 0) {
        boostTarget_ = 10;
        boost_ = amt;
        boostRate_ = rate;
    }
    else {
        boostTarget_ = v_ + speedup;
        boost_ = amt;
        boostRate_ = rate;
    }
    
    [self toggleBoostFlame:YES];    
}

- (void) useBoost
{
    if (!inputLocked_) {
        // The first time the player pressed the boost button
        if (onGround_) {
            onGround_ = NO;
            inputLocked_ = YES;
            [self engageBoost:v0_ amt:0.001 rate:0.0005];
            CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(takeOffComplete)];
            CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:6.0 position:CGPointMake(rocket_.position.x, screenHeight_ * 0.3)];
            CCActionInterval *seq = [CCSequence actions:move, done, nil];
            [rocket_ runAction:seq];
            [rocket_ showShaking];
        }
        else {
#if !DEBUG_UNLIMITED_BOOSTS
            if (numBoosts_ > 0) {
#endif
                numBoosts_--;
                [numBoostsLabel_ setString:[NSString stringWithFormat:@"%d", numBoosts_]];
                [self engageBoost:vBoost_ amt:0.01 rate:0.005];
                [self showText:kSpeedUp];                
#if !DEBUG_UNLIMITED_BOOSTS                
            }
#endif
        }
    }
}

- (void) slowDown:(CGFloat)factor
{
    v_ *= factor;
    if (v_ < 1) {
        v_ = 1;
        dv_ = 0;
    }
    [self showText:kSpeedDown];
}

- (void) collectBoost:(Boost *)boost
{
    [obstacles_ removeObject:boost];
    [self showText:kSpeedUp];    
    [self engageBoost:vBoostRing_ amt:0.01 rate:0.005];    
}

- (void) collectFuel:(Fuel *)fuel
{
    numBoosts_++;
    [numBoostsLabel_ setString:[NSString stringWithFormat:@"%d", numBoosts_]];
    [self showText:kBoostPlus];    
    [obstacles_ removeObject:fuel];
}

- (void) collectCat:(Cat *)cat
{
    numCats_++;
    [numCatsLabel_ setString:[NSString stringWithFormat:@"%d", numCats_]];    
    [self showText:kCatPlus];    
    [obstacles_ removeObject:cat];
}

- (void) showText:(EventText)event
{
    CCSprite *text;
    
    switch (event) {
        case kSpeedUp:
            text = [CCSprite spriteWithSpriteFrameName:@"Speed Up Text.png"];
            break;
        case kSpeedDown:
            text = [CCSprite spriteWithSpriteFrameName:@"Speed Down Text.png"];            
            break;
        case kCatPlus:
            text = [CCSprite spriteWithSpriteFrameName:@"Cat Plus Text.png"];            
            break;
        case kBoostPlus:
            text = [CCSprite spriteWithSpriteFrameName:@"Boosters Plus Text.png"];            
            break;
        default:
            NSAssert(NO, @"Invalid event type");
    }
    
    [rocket_ addChild:text z:kLabelDepth];
    
    NSUInteger rand = arc4random() % 2;
    switch (rand) {
        case 0:
            text.position = CGPointMake(-15, 35);            
            text.rotation = -15;
            break;
        case 1:
            text.position = CGPointMake(15, 35);            
            text.rotation = 15;
            break;
        default:
            text.position = CGPointMake(0, 35);            
    }
    
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.2];
    CCFiniteTimeAction *fade = [CCFadeOut actionWithDuration:0.5];
    CCCallFuncND *clean = [CCCallFuncND actionWithTarget:self selector:@selector(removeText:data:) data:text];
    [text runAction:[CCSequence actions:delay, fade, clean, nil]];
}

- (void) removeText:(id)node data:(CCSprite *)text
{
    [text removeFromParentAndCleanup:YES];
}

- (void) removeObstacle:(Obstacle *)obstacle
{
    [obstacles_ removeObject:obstacle];
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
    const float kFilteringFactor = 0.2f;
    
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

    [tiltLabel_ setString:[NSString stringWithFormat:@"%1.3f", resultx]];
    
    sideMoveSpeed_ = resultx*30;    

    if (sideMoveSpeed_ > 6) {
        sideMoveSpeed_ = 6;
    }
    if (sideMoveSpeed_ < -6) {
        sideMoveSpeed_ = -6;
    }
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
