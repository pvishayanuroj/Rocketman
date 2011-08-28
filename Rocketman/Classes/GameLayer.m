//
//  GameLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "GameManager.h"
#import "AudioManager.h"
#import "GameStateManager.h"
#import "Rocket.h"
#import "Obstacle.h"
#import "Doodad.h"
#import "Parallax.h"
#import "Ground.h"
#import "Cloud.h"
#import "SlowCloud.h"
#import "Alien.h"
#import "UFO.h"
#import "Flybot.h"
#import "Dino.h"
#import "Angel.h"
#import "Shell.h"
#import "Turtling.h"
#import "ShockTurtling.h"
#import "YellowBird.h"
#import "SwarmGenerator.h"
#import "HoverTurtle.h"
#import "AlienHoverTurtle.h"
#import "BossTurtle.h"
#import "PlasmaBall.h"
#import "Cat.h"
#import "CatBullet.h"
#import "Fuel.h"
#import "Boost.h"
#import "BlastCloud.h"
#import "UtilFuncs.h"
#import "Boundary.h"
#import "TargetedAction.h"

#import "HighscoreManager.h"

@implementation GameLayer

#pragma mark - Object Lifecycle

+ (id) startWithLevel:(NSUInteger)levelNum
{
    return [[[self alloc] initWithLevel:levelNum] autorelease];
}

- (id) initWithLevel:(NSUInteger)levelNum
{
	if ((self = [super init])) {

        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        [[GameManager gameManager] registerGameLayer:self];
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        
        screenWidth_ = size.width;
        screenHeight_ = size.height;        
        
        yCutoff_ = -screenHeight_ * 3;
        xCutoff_ = screenWidth_ * 2;
        leftCutoff_ = SIDE_MARGIN;
        rightCutoff_ = screenWidth_ - SIDE_MARGIN;
        
        // Array initialization
        obstacles_ = [[NSMutableArray arrayWithCapacity:20] retain];
        firedCats_ = [[NSMutableArray arrayWithCapacity:5] retain];
        doodads_ = [[NSMutableArray arrayWithCapacity:20] retain]; 
        
        // Determine filenames
        NSString *bgFile = [NSString stringWithFormat:@"background_level%d.png", levelNum];
        NSString *pbgFile = [NSString stringWithFormat:@"parallax_level%d.png", levelNum];
        NSString *gndFile = [NSString stringWithFormat:@"ground_level%d.png", levelNum];
        
        // Add background
        CCSprite *bg = [CCSprite spriteWithFile:bgFile];
        [self addChild:bg z:kBackgroundDepth];
        bg.anchorPoint = CGPointZero;
        
        // Parallax background
        Doodad *pbg = [Parallax parallaxWithFile:pbgFile];
        [self addChild:pbg z:kBackgroundDepth];
        [doodads_ addObject:pbg];
        
        // Add ground 
        Doodad *ground = [Ground groundWithPos:CGPointZero filename:gndFile];
        [self addChild:ground z:kGroundDepth];
        [doodads_ addObject:ground];                
        
        // Add the rocket
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.15);
        rocket_ = [[Rocket rocketWithPos:startPos] retain];
        [self addChild:rocket_ z:kRocketDepth];
        [[GameManager gameManager] registerRocket:rocket_];
        
        // Game variables
        rocketSpeed_ = 0;
        numCats01_ = 0;
        numCats02_ = 0;
        numBoosts_ = 0;
        height_ = 0;
        maxHeight_ = 0;
        nextCloudHeight_ = 0;
        nextSlowCloudHeight_ = 0;
        
        // Obstacle and powerup generation
        nextObstacleHeight_ = 800;
        obstableFrequency_ = 2000;
        nextRingHeight_ = 1600;
        ringFrequency_ = 2000;
        nextCatHeight_ = 700;
        catFrequency_ = 1200;
        nextFuelHeight_ = 2000;
        fuelFrequency_ = 2400;

        sideMoveSpeed_ = 0;
        maxSideMoveSpeed_ = 8;
        boostEngaged_ = NO;
        boostTimer_ = 0;        
        onGround_ = YES;
        inputLocked_ = NO;
        lossTriggered_ = NO;
        
        // DEBUG
        bossAdded_ = NO;
        ammoType_ = 0;
        
        v_ = 0;
#if DEBUG_CONSTANTSPEED
        v0_ = 6;
#else
        v0_ = 9;
#endif
        vBoost_ = 5;
        vBoostRing_ = 4; 
        dv_ = 0;
        ddv_ = 0.00002;
        vMax_ = 13;
        
        dt_ = 0;    

        [self schedule:@selector(update:) interval:1.0/60.0];
        [self schedule:@selector(slowUpdate:) interval:10.0/60.0];
	}
	return self;
}

- (void) dealloc
{
    NSLog(@"Game Layer dealloc'd");
    
    for (Obstacle *obstacle in obstacles_) {
        [obstacle destroy];
    }
    
    [rocket_ release];
    [obstacles_ release];
    [firedCats_ release];
    [doodads_ release];
    
    [super dealloc];
}

#pragma mark - Update Loops

- (void) update:(ccTime)dt
{    
    [self physicsStep:dt];
    [self applyBoost:dt];
    [self updateCounters];
    [self applyGravity];
    [self moveRocketHorizontally];
    [self collisionDetect];        
}

- (void) slowUpdate:(ccTime)dt
{
    [self cloudGenerator];    
    [self obstacleGenerator];        
    [self bossGenerator]; 
}

- (void) physicsStep:(ccTime)dt
{
#if DEBUG_CONSTANTSPEED
    return;
#endif
    
    if (!onGround_) {
        /*
        if (v_ < 7) {
            v_ -= 0.02;
        }
        else if (v_ < 4) {
            v_ -= 0.03;
        }
        else {
            v_ -= 0.0022222;
        }
        
        rocketSpeed_ = v_;
        */
            
        v_ += dv_;
        rocketSpeed_ = v_;

        dv_ -= ddv_;      
        if (v_ < 7) {
            ddv_ += 0.000001; // Used to be 1
        }
        else {
            ddv_ = 0.00001;
//            ddv_ += 0.000000001;
        }

        // Turn the engine off if we are falling
        if (rocketSpeed_ < 0) {
            [rocket_ turnFlameOff];
        }
    }
}

- (void) applyBoost:(ccTime)dt
{
    // If boosting
    if (boostEngaged_) {
        
        boostTimer_ -= dt;
        
        // Actual boosting
        v_ += boost_;
        boost_ += boostRate_;
        
        BOOL vCond = v_ > vMax_ || v_ > boostTarget_;
        BOOL tCond = (boostTimer_ <= 0);
        
        // Cut the boost when either vtarget/vmax is reached or the timer runs out, whichever is longer
        if (vCond && tCond) {
            boostEngaged_ = NO;
            [rocket_ toggleBoostOn:NO];
        }
        
        // Limit the boost to the target speed or vmax
        if (v_ > vMax_) {
            v_ = vMax_;
        }
        if (v_ > boostTarget_) {
            v_ = boostTarget_;
        }
        
        rocketSpeed_= v_;
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
    
    [[GameManager gameManager] setHeight:height_];
    [[GameManager gameManager] setSpeed:rocketSpeed_];
}

- (void) collisionDetect
{
#if DEBUG_NOCOLLISIONS
    return;
#endif
    
    // Setup the bounding box of the rocket
    CGRect rocketBox;
    rocketBox.size = rocket_.rect.size;
    rocketBox.origin = rocket_.position;
    
    // For checking if the rocket collides with obstacles
    for (Obstacle *obstacle in obstacles_) {
        // Each object may have multiple boundaries to collide with
        for (Boundary *boundary in obstacle.boundaries) {
            [boundary collisionCheckAndHandle:obstacle.position rocketBox:rocketBox];
        }
    }
    
    // For removal of objects
    NSMutableIndexSet *remove = [NSMutableIndexSet indexSet];    
    NSInteger index = 0;            
    
    // For checking cat bullet collisions with obstacles
    for (CatBullet *cat in firedCats_) {
        for (Obstacle *obstacle in obstacles_) {
            // Check all boundaries of an object (may be many)
            for (Boundary *boundary in obstacle.boundaries) {
                if ([boundary hitCheckAndHandle:obstacle.position catPos:cat.position catRadius:cat.radius]) {
                    // Decrement the number of impacts the bullet can have
                    cat.remainingImpacts--;
                    
                    // Only remove the bullet if it has hit enough times
                    if (cat.remainingImpacts <= 0) {
                        [remove addIndex:index];
                        [cat removeFromParentAndCleanup:YES];       
                    }                            
                    
                    // Check if the bullet is "explosive"
                    if (cat.explosionRadius > 0) {
                        // If it is, check to see if any other obstacle in proximity will be affected
                        for (Obstacle *obs in obstacles_) {
                            for (Boundary *b in obs.boundaries) {
                                [b hitCheckAndHandle:obs.position catPos:cat.position catRadius:cat.explosionRadius];
                            }             
                        }
                    }                    
                }
            } // end boundary loop
        } // end obstacle loop
        index++;
    } // end cat bullet collision loop

    // For the removal of cat bullets
    [firedCats_ removeObjectsAtIndexes:remove];

    // Reset
    [remove removeAllIndexes];
    index = 0;        
    
    // Obstacle removal loop - removes all obstacles that may have been flagged in any of
    // the collision checks above
    for (Obstacle *obstacle in obstacles_) {
        if (obstacle.destroyed) {
            [obstacle destroy];
            [remove addIndex:index];
        }
        index++;
    }    
    
    // For removal of obstacles
    [obstacles_ removeObjectsAtIndexes:remove];    
}

- (void) applyGravity
{
    NSMutableIndexSet *remove;
    NSUInteger index;
    
#if DEBUG_SHOWNUMOBJECTS
    NSLog(@"DOODADS: %d - - OBSTACLES: %d - - BULLETS: %d", [doodads_ count], [obstacles_ count], [firedCats_ count]); 
#endif
    
    // Doodads
    remove = [NSMutableIndexSet indexSet];
    index = 0;
    
    for (Doodad *doodad in doodads_) {
        [doodad fall:rocketSpeed_];

        // If past the cutoff boundary, delete
        if (doodad.position.y < yCutoff_ || doodad.position.x > xCutoff_) {
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
        if (obstacle.position.y < yCutoff_ || obstacle.position.x > xCutoff_) {
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
        
        NSInteger xCoord = [self getRandomX];
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

- (void) bossGenerator
{
    if (height_ > 1000) {
        if (!bossAdded_) {
            bossAdded_ = YES;
            NSInteger x = [self getRandomX];
            NSInteger y = screenHeight_ + 100;
            CGPoint pos = ccp(x, y);          
            //[self addObstacle:kBossTurtle pos:pos];
        }
    }
}

- (void) obstacleGenerator
{
    NSInteger x;
    NSInteger y;
    CGPoint pos;
    Obstacle *obstacle;    
    
#if !DEBUG_NOOBSTACLES
    // "Bad" obstacles
    if (height_ > nextObstacleHeight_) {
        nextObstacleHeight_ += [self getRandomY:obstableFrequency_];
        
        x = [self getRandomX];
        y = screenHeight_ + 100;
        pos = ccp(x, y);                

        //NSUInteger type = arc4random() % 8; 
        NSUInteger type = [UtilFuncs randomIncl:7 b:10];
        //type = kAlienHoverTurtle;
        [self addObstacle:type pos:pos];
        //[self addBirdSwarm:8];
        //[self addTurtlingSwarm:8];        
    }    
#endif
    
#if !DEBUG_NORINGS
    // Boost rings
    if (height_ > nextRingHeight_) {
        nextRingHeight_ += [self getRandomY:ringFrequency_];
        
        x = [self getRandomX];
        y = screenHeight_ + 100;
        pos = ccp(x, y);
        
        obstacle = [Boost boostWithPos:pos];        
        [self addChild:obstacle z:kObstacleDepth];
        [obstacles_ addObject:obstacle];
    }
#endif
    
    // Cats
    if (height_ > nextCatHeight_) {
        nextCatHeight_ += [self getRandomY:catFrequency_];
        
        x = [self getRandomX];
        y = screenHeight_ + 100;
        pos = ccp(x, y);
        
        obstacle = [Cat catWithPos:pos];
        [self addChild:obstacle z:kObstacleDepth];
        [obstacles_ addObject:obstacle];
    }
    
    // Fuel
    if (height_ > nextFuelHeight_) {
        nextFuelHeight_ += [self getRandomY:fuelFrequency_];
        
        x = [self getRandomX];
        y = screenHeight_ + 100;
        pos = ccp(x, y);
        
        obstacle = [Fuel fuelWithPos:pos];
        [self addChild:obstacle z:kObstacleDepth];
        [obstacles_ addObject:obstacle];
    }    
}

- (void) moveRocketHorizontally
{
    CGPoint pos;
    CGFloat dx = 0;
    
    dx = sideMoveSpeed_;

#if DEBUG_ALTERNATETILT
    CGFloat deltax = targetX_ - rocket_.position.x;
    CGFloat absoluteMax = 7;
    CGFloat maxSpeed = fabs(deltax)/3.0f;
    if (maxSpeed > absoluteMax) {
        maxSpeed = absoluteMax;
    }
        
    if (deltax > maxSpeed) {
        dx = maxSpeed;
    }
    else if (deltax < -maxSpeed) {
        dx = -maxSpeed ;
    }
    else {
        dx = deltax;
    }
    //NSLog(@"deltax: %3.2f, dx: %2.2f", deltax, dx);
#endif
    
    CGPoint moveAmt = CGPointMake(dx, 0);
    pos = ccpAdd(rocket_.position, moveAmt);
    if (pos.x > leftCutoff_ && pos.x < rightCutoff_ && !onGround_ && !inputLocked_) {
        rocket_.position = pos;
    }
}

#pragma mark - Misc Methods

- (NSInteger) getRandomX
{
    NSInteger xCoord = arc4random() % (screenWidth_ - (SIDE_MARGIN * 2));       
    xCoord += SIDE_MARGIN;
    
    return xCoord;
}

- (NSInteger) getRandomY:(CGFloat)freq
{
    NSInteger range = freq * 0.2;
    NSInteger var = arc4random() % (range * 2);       
    var -= range;
    
    return (freq + var);
}

- (void) loss
{
    if (!lossTriggered_) {
        lossTriggered_ = YES;
        onGround_ = YES;
        rocketSpeed_ = 0;

        // Very important to do this, since the accelerometer singleton is holding a ref to us
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        
        CCFiniteTimeAction *fall = [CCMoveBy actionWithDuration:0.2f position:CGPointMake(0, -300)];
        TargetedAction *rocketFall = [TargetedAction actionWithTarget:rocket_ actionIn:fall];
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:2.0f];
        CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(endLevel)];
        [self runAction:[CCSequence actions:rocketFall, delay, method, nil]];
    }
}

- (void) endLevel
{
    [[GameStateManager gameStateManager] endGame:height_];   
}

- (void) addBirdSwarm:(NSInteger)size
{
    [SwarmGenerator addHorizontalSwarm:size gameLayer:self type:kYellowBird];
}

- (void) addTurtlingSwarm:(NSInteger)size
{
    [SwarmGenerator addVerticalSwarm:size gameLayer:self type:kTurtling];
}

- (void) addObstacle:(ObstacleType)type pos:(CGPoint)pos
{
    Obstacle *obstacle;
    BOOL add = YES;
    
    switch (type) {
        case kDino:
            obstacle = [Dino dinoWithPos:pos];
            break;
        case kAlien:
            obstacle = [Alien alienWithPos:pos];
            break;
        case kShell:
            obstacle = [Shell shellWithPos:pos];
            break;
        case kAngel:
            obstacle = [Angel angelWithPos:pos];
            break;                
        case kUFO:
            obstacle = [UFO ufoWithPos:pos];
            break;
        case kFlybot:
            obstacle = [Flybot flyBotWithPos:pos];
            break;
        case kHoverTurtle:
            obstacle = [HoverTurtle hoverTurtleWithPos:pos];
            break;
        case kAlienHoverTurtle:
            obstacle = [AlienHoverTurtle alienHoverTurtleWithPos:pos];
            break;
        case kTurtlingSwarm:
            [self addTurtlingSwarm:8];
            add = NO;
            break;
        case kBirdSwarm:
            [self addBirdSwarm:8];
            add = NO;
            break;
        case kBoost:
            obstacle = [Boost boostWithPos:pos];    
            break;
        case kCat:
            obstacle = [Cat catWithPos:pos];            
            break;
        case kFuel:
            obstacle = [Fuel fuelWithPos:pos];            
            break;
        case kBossTurtle:
            obstacle = [BossTurtle bossTurtleWithPos:pos];            
            break;
        case kTurtling:
            obstacle = [Turtling turtlingWithPos:pos];
            break;
        case kYellowBird:
            obstacle = [YellowBird yellowBirdWithPos:pos];
            break;
        case kShockTurtling:
            obstacle = [ShockTurtling shockTurtlingWithPos:pos];
            break;
        case kPlasmaBall:
            obstacle = [PlasmaBall plasmaBallWithPos:pos];
            break;
        default:
            NSAssert(NO, @"Invalid obstacle number selected");
            break;
    }
    
    if (add) {
        [self addChild:obstacle z:kObstacleDepth];
        [obstacles_ addObject:obstacle]; 
    }
}

- (void) fireCat01
{
    if (!onGround_ && !inputLocked_) {        
#if !DEBUG_UNLIMITED_CATS        
        if (numCats01_ > 0) {
#endif
            CatBullet *bullet;
            
            // DEBUG!!
            NSInteger s = ammoType_++ % 2;
            
            switch (s) {
                case 0:
                    numCats01_--;
                    [[GameManager gameManager] setNumCats01:numCats01_]; 
                    bullet = [CatBullet catBulletWithPos:rocket_.position withSpeed:(rocketSpeed_ + 10)];
                    break;
                case 1:
                    numCats01_--;
                    [[GameManager gameManager] setNumCats01:numCats01_]; 
                    bullet = [CatBullet longBulletWithPos:rocket_.position withSpeed:(rocketSpeed_ + 10)];
                    break;
                default:
                    numCats01_--;
                    [[GameManager gameManager] setNumCats01:numCats01_]; 
                    bullet = [CatBullet catBulletWithPos:rocket_.position withSpeed:(rocketSpeed_ + 10)];
            }
            
            [self addChild:bullet z:kBulletDepth];
            [firedCats_ addObject:bullet];
            [[AudioManager audioManager] playSound:kMeow];
#if !DEBUG_UNLIMITED_CATS
        }
#endif
    }
}

- (void) fireCat02
{
    if (!onGround_ && !inputLocked_) {   
#if !DEBUG_UNLIMITED_CATS        
        if (numCats02_ > 0) {
#endif
            CatBullet *bullet;
            numCats02_--;
            [[GameManager gameManager] setNumCats02:numCats02_]; 
            bullet = [CatBullet fatBulletWithPos:rocket_.position withSpeed:(rocketSpeed_ + 10)];
            
            [self addChild:bullet z:kBulletDepth];
            [firedCats_ addObject:bullet];
            [[AudioManager audioManager] playSound:kMeow];
            
#if !DEBUG_UNLIMITED_CATS
        }
#endif
    }
}

- (void) takeOffComplete
{
    onGround_ = NO;    
    inputLocked_ = NO;
}

- (void) setRocketCondition:(RocketCondition)condition
{
    switch (condition) {
        case kRocketBurning:
            [rocket_ showBurning];
            break;
        case kRocketWobbling:
            [rocket_ showWobbling];
            break;
        case kRocketHearts:
            [rocket_ showHeart];
            break;
        default:
            NSAssert(NO, @"Invalid Rocket Condition");
    }
}

- (void) engageBoost:(CGFloat)speedup amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time
{
    // The boost amount is how much is speed is added per tick
    // The rate is how much the boost amount is changed per tick
    
    dv_ = 0;
    ddv_ = 0.00002;
    
    boostEngaged_ = YES;
    boostTimer_ = time;
    
    if (v_ < 0) {
        boostTarget_ = v0_;
        boost_ = amt;
        boostRate_ = rate;
    }
    else {
        //boostTarget_ = v_ + 8;
        boostTarget_ = v_ + speedup;
        boost_ = amt;
        boostRate_ = rate;
    }
    
    [rocket_ toggleBoostOn:YES];    
}

- (void) engageFixedBoost:(CGFloat)speed amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time
{
    // The speed is the target speed to stop at
    // The boost amount is how much is speed is added per tick
    // The rate is how much the boost amount is changed per tick    
    
    dv_ = 0;
    ddv_ = 0.00002;
    
    boostEngaged_ = YES;
    boostTimer_ = time;
    
    boostTarget_ = speed;
    boost_ = amt;
    boostRate_ = rate;
    
    [rocket_ toggleBoostOn:YES];        
}

- (void) useBoost
{
    if (!inputLocked_) {
        // The first time the player pressed the boost button
        if (onGround_) {
            inputLocked_ = YES;
            // Engage boost, slow boosting, so we don't care about time
            [self engageBoost:v0_ amt:0.001 rate:0.0005 time:1];
            CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:6.0 position:CGPointMake(rocket_.position.x, screenHeight_ * 0.3)];
            [rocket_ runAction:move];
            [rocket_ showShaking];
            [[AudioManager audioManager] playSound:kTheme01];
        }
        // Else the typical case when player is already flying
        else {
#if !DEBUG_UNLIMITED_BOOSTS
            if (numBoosts_ > 0) {
#endif
                numBoosts_--;
                
                // TEMPORARY FOR NOW
                if (boostEngaged_) {
                    NSInteger random = arc4random() % 2;
                    [rocket_ showAuraForDuration:3.0f];                    
                    [[GameManager gameManager] showCombo:random+1];
                }
                /////////////////
                
                [[GameManager gameManager] setNumBoosts:numBoosts_];
                // Engage fast boost, make sure it lasts longer
                [self engageBoost:vBoost_ amt:5 rate:0 time:1.5];
                [self showText:kSpeedUp];                
#if !DEBUG_UNLIMITED_BOOSTS                
            }
#endif
        }
    }
}

- (void) slowDown:(CGFloat)factor
{
#if DEBUG_CONSTANTSPEED || DEBUG_NOSLOWDOWN
    return;
#endif
    if (v_ > 0) {
        v_ *= factor;
    }
    // Cancel boost if on
    if (boostEngaged_) {
        boostEngaged_ = NO;
        [rocket_ toggleBoostOn:NO];        
    }

    [self showText:kSpeedDown];
}

- (void) collectBoost:(Boost *)boost
{
    [self showText:kSpeedUp];    
    [[AudioManager audioManager] playSound:kKerrum];
    
#if DEBUG_CONSTANTSPEED
    return;
#endif    
    // Engage fast boost, make sure it lasts longer    
    [self engageBoost:vBoostRing_ amt:0.5 rate:0 time:1.5];    
}

- (void) collectFuel:(Fuel *)fuel
{
    numBoosts_++;
    [[GameManager gameManager] setNumBoosts:numBoosts_];
    [self showText:kBoostPlus];   
    [[AudioManager audioManager] playSound:kPowerup];
}

- (void) collectCat:(Cat *)cat
{
    numCats01_++;
    [[GameManager gameManager] setNumCats01:numCats01_];
    [self showText:kCatPlus];
    [[AudioManager audioManager] playSound:kCollectMeow];    
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

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //ramp-speed - play with this value until satisfied
    const float kFilteringFactor = 0.2f;
    
    //high-pass filter to eleminate gravity
    accel[0] = acceleration.x * kFilteringFactor + accel[0] * (1.0f - kFilteringFactor);
    
    CGFloat resultx = acceleration.x - accel[0]; 
    
    [[GameManager gameManager] setTilt:resultx];
    
#if DEBUG_ALTERNATETILT
    CGFloat cutoff = 0.25;
    CGFloat ax = accel[0];
    if (ax < -cutoff) {
        ax = -cutoff;
    }
    if (ax > cutoff) {
        ax = cutoff;
    }
    
    CGFloat tx = ax * 160/cutoff + 160;
    targetX_ = tx;
#endif
    
    sideMoveSpeed_ = resultx*60;    

    CGFloat maxSpeed = 10;
    
    if (sideMoveSpeed_ > maxSpeed) {
        sideMoveSpeed_ = maxSpeed;
    }
    if (sideMoveSpeed_ < -maxSpeed) {
        sideMoveSpeed_ = -maxSpeed ;
    }
}

@end
