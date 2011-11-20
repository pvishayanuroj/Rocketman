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
#import "DataManager.h"
#import "Rocket.h"
#import "Obstacle.h"
#import "ObjectHeaders.h"
#import "Doodad.h"
#import "Parallax.h"
#import "Ground.h"
#import "RockDebris.h"
#import "Cloud.h"
#import "SlowCloud.h"
#import "DebrisGenerator.h"
#import "SwarmGenerator.h"
#import "CatBullet.h"
#import "UtilFuncs.h"
#import "Boundary.h"
#import "TargetedAction.h"
#import "PhysicsModule.h"
#import "WallModule.h"
#import "ComboModule.h"
#import "EventText.h"
#import "Banner.h"

#import "HighscoreManager.h"

@implementation GameLayer

@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

+ (id) startWithLevelData:(NSDictionary *)data
{
    return [[[self alloc] initWithLevelData:data] autorelease];
}

- (id) initWithLevelData:(NSDictionary *)data
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
        
        NSString *backgroundName = [data objectForKey:@"Background File"];
        NSString *groundName = [data objectForKey:@"Ground File"];
        NSString *parallaxName = [data objectForKey:@"Parallax File"];        
        NSString *wallName = [data objectForKey:@"Wall File"];
        
        // Add background
        CCSprite *bg = [CCSprite spriteWithFile:backgroundName];
        [self addChild:bg z:kBackgroundDepth];
        bg.anchorPoint = CGPointZero;
        
        // Add parallax background
        if (parallaxName) {
            Doodad *pbg = [Parallax parallaxWithFile:parallaxName];
            [self addChild:pbg z:kParallaxDepth];
            [doodads_ addObject:pbg];
        }

        // Add the ground
        if (groundName) {
            // Add ground 
            Doodad *ground = [Ground groundWithPos:CGPointZero filename:groundName];
            [self addChild:ground z:kGroundDepth];
            [doodads_ addObject:ground];                
        }
        
        // Add wall
        if (wallName) {
            wall_ = [[WallModule wallModule:wallName] retain];
        }
        else {
            wall_ = nil;
        }
        
        // Load object data
        objectNameMap_ = [[UtilFuncs mapObjectTypes] retain];
        
        objectData_ = [[data objectForKey:@"Data"] retain];
        objectDataKeys_ = [[data objectForKey:@"Datakeys"] retain];
                
        dataKeyIndex_ = 0;
        nextHeightTrigger_ = [[objectDataKeys_ objectAtIndex:dataKeyIndex_] integerValue];
        
        // Add physics module
        physics_ = [[PhysicsModule physicsModule] retain];
        physics_.delegate = self;
        
        // Add combo module
        combo_ = [[ComboModule comboModule] retain];
        
        // Add the rocket
        CGPoint startPos = CGPointMake(screenWidth_ * 0.5, screenHeight_ * 0.15);
        rocket_ = [[Rocket rocketWithPos:startPos] retain];
        rocket_.delegate = self;
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

        sideMoveSpeed_ = 0;
        maxSideMoveSpeed_ = 8; 
        onGround_ = YES;
        inputLocked_ = NO;
        lossTriggered_ = NO;
        
        [self schedule:@selector(update:) interval:1.0/60.0];
        [self schedule:@selector(slowUpdate:) interval:10.0/60.0];
	}
	return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS      
    NSLog(@"Game Layer dealloc'd");
#endif
    
    for (Obstacle *obstacle in obstacles_) {
        [obstacle destroy];
    }
    
    [rocket_ release];
    [physics_ release];
    [wall_ release];
    [combo_ release];
    [obstacles_ release];
    [firedCats_ release];
    [doodads_ release];
    [objectData_ release];
    [objectDataKeys_ release];
    [objectNameMap_ release];
    
    [super dealloc];
}

#pragma mark - Update Loops

- (void) update:(ccTime)dt
{    
    [physics_ step:dt];
    [self updateCounters];
    [self applyGravity];
    [self moveRocketHorizontally];
    [self collisionDetect];       
    [self obstacleGenerator];      
}

- (void) slowUpdate:(ccTime)dt
{
    [self cloudGenerator];    
      
}

- (void) updateCounters
{
    // Keep track of height
    height_ += physics_.rocketSpeed;
    if (height_ > maxHeight_) {
        maxHeight_ = height_;
        lossHeight_ = height_ - screenHeight_ * 3;
    }
    
    // Check for lose condition
    if (height_ < lossHeight_) {
        [self loss];
    }
    
    [wall_ heightUpdate:height_];
    [delegate_ heightUpdate:height_];
    [delegate_ speedUpdate:physics_.rocketSpeed];
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
        [doodad fall:physics_.rocketSpeed];

        // If past the cutoff boundary or doodad has been destroyed (for unmoving doodads), delete
        if (doodad.position.y < yCutoff_ || doodad.position.x > xCutoff_ || doodad.destroyed) {
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
    
    // Important: Make a copy of the obstacles array, because the fall method can spawn new obstacles 
    for (Obstacle *obstacle in [[obstacles_ copy] autorelease]) {
        [obstacle fall:physics_.rocketSpeed];
        
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
        [cat fall:physics_.rocketSpeed];
        
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
        [self addDoodad:kCloud pos:pos];
    }
    
    if (height_ > nextSlowCloudHeight_) {
        nextSlowCloudHeight_ += 1500;
        
        NSInteger xCoord = arc4random() % screenWidth_;
        NSInteger yCoord = screenHeight_ + arc4random() % screenHeight_;
        
        CGPoint pos = CGPointMake(xCoord, screenHeight_ + yCoord);        
        [self addDoodad:kSlowCloud pos:pos];
    }    
}

- (void) obstacleGenerator
{
    // See if the specified height for the next object addition has been reached
    if ((height_ - screenHeight_) > nextHeightTrigger_) {
        // Get the key to determine which row to add
        NSString *datakey = [objectDataKeys_ objectAtIndex:dataKeyIndex_];
        NSDictionary *rowData = [objectData_ objectForKey:datakey];
        dataKeyIndex_++;
        
        //NSLog(@"Height trigger: %@", datakey);
        
        // For all objects that are to be added in this row
        for (NSString *col in rowData) {
            NSInteger x = [col integerValue];
            NSString *objectName = [rowData objectForKey:col];
            CGPoint pos = CGPointMake(x, 1000);
            
            ObstacleType type = [[objectNameMap_ objectForKey:objectName] intValue];
            [self addObstacle:type pos:pos];
        }
        
        // Determine the next height to trigger on
        if (dataKeyIndex_ < [objectDataKeys_ count]) {
            nextHeightTrigger_ = [[objectDataKeys_ objectAtIndex:dataKeyIndex_] integerValue];
        }
        // No more objects to add
        else {
            nextHeightTrigger_ = INT_MAX;
        }
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
        dx = -maxSpeed;
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

- (void) win
{
    inputLocked_ = YES;
    
    // Very important to do this, since the accelerometer singleton is holding a ref to us
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];    
    
    [rocket_ showVictoryBoost];
}

- (BOOL) bannerClicked
{
    return YES;
}

- (void) bannerClosed
{
    delegate_ = nil;
    [[GameStateManager gameStateManager] endGame:height_];       
}

- (void) victoryBoostComplete
{
    // Stop the movement and show the victory banner
    [physics_ worldStop];
    
    Banner *banner = [Banner banner:R_VICTORY_BANNER delay:0.0f];
    banner.position = CGPointMake(160.0f, 300.0f);
    banner.delegate = self;
    [self addChild:banner z:kLabelDepth];
}

- (void) loss
{
    if (!lossTriggered_) {
        lossTriggered_ = YES;
        onGround_ = YES;
        rocketSpeed_ = 0;

        [self unschedule:@selector(update:)];
        
        // Very important to do this, since the accelerometer singleton is holding a ref to us
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        
        [rocket_ showLosingFall];
    }
}

- (void) losingFallComplete
{
    [[GameStateManager gameStateManager] endGame:height_];   
}

- (void) addBirdSwarm:(NSInteger)size
{
    [SwarmGenerator addHorizontalSwarm:size gameLayer:self type:kSwarmYellowBird];
}

- (void) addTurtlingSwarm:(NSInteger)size
{
    [SwarmGenerator addVerticalSwarm:size gameLayer:self type:kSwarmTurtling];
}

- (void) addDoodad:(DoodadType)type pos:(CGPoint)pos
{
    Doodad *doodad;
    BOOL add = YES;
    
    switch (type) {
        case kSlowCloud:
            doodad = [SlowCloud slowCloudWithPos:pos];
            break;
        case kCloud:
            doodad = [Cloud cloudWithPos:pos];            
            break;
        case kDebrisGen:
            add = NO;
            [DebrisGenerator addDebris:self type:kRockDebris pos:pos];
            break;
        default:
            NSLog(@"Invalid obstacle number");            
            break;
    }
    
    if (add) {
        [self addDoodad:doodad];         
    }
}

- (void) addDoodad:(Doodad *)doodad
{
    [self addChild:doodad z:doodad.zDepth];   
    [doodads_ addObject:doodad];   
}

- (void) addObstacle:(ObstacleType)type pos:(CGPoint)pos
{
    Obstacle *obstacle;
    BOOL add = YES;
    
    switch (type) {
        case kAlien:
            obstacle = [Alien alienWithPos:pos];
            break;               
        case kUFO:
            obstacle = [UFO ufoWithPos:pos];
            break;
        case kFlybot:
            obstacle = [Flybot flyBotWithPos:pos];
            break;
        case kTurtling:
            obstacle = [Turtling turtlingWithPos:pos];
            break;
        case kTurtlingSwarm:
            [self addTurtlingSwarm:8];
            add = NO;
            break;   
        case kShockTurtling:
            obstacle = [ShockTurtling shockTurtlingWithPos:pos];
            break;            
        case kHoverTurtle:
            obstacle = [HoverTurtle hoverTurtleWithPos:pos];
            break;
        case kAlienHoverTurtle:
            obstacle = [AlienHoverTurtle alienHoverTurtleWithPos:pos];
            break;
        case kShieldedAlienHoverTurtle:
            obstacle = [AlienHoverTurtle shieldedAlienHoverTurtleWithPos:pos];
            break;         
        case kYellowBird:
            obstacle = [YellowBird yellowBirdWithPos:pos];
            break;
        case kYellowBirdSwarm:
            [self addBirdSwarm:8];
            add = NO;
            break;     
        case kBlueBird:
            obstacle = [BlueBird blueBirdWithPos:pos];
            break;
        case kBlueBirdSwarm:
            [SwarmGenerator addVerticalSwarm:8 gameLayer:self type:kSwarmBlueBird];            
            add = NO;
            break;
        case kBat:
            obstacle = [Bat batWithPos:pos];
            break;
        case kBatSwarm:
            [SwarmGenerator addVerticalSwarm:8 gameLayer:self type:kSwarmBat];
            add = NO;
            break;
        case kSquid:
            obstacle = [Squid squidWithPos:pos];
            break;
        case kBlueFish:
            obstacle = [BlueFish blueFishWithPos:pos];
            break;
        case kBlueFishSwarm:
            [SwarmGenerator addHorizontalSwarm:8 gameLayer:self type:kSwarmBlueFish];            
            add = NO;
            break;
        case kSalamanderRight:
            obstacle = [Salamander salamanderWithPos:pos type:type];
            break;
        case kSalamanderLeft:
            obstacle = [Salamander salamanderWithPos:pos type:type];
            break;
        case kProximitySalamanderRight:
            obstacle = [Salamander salamanderWithPos:pos type:type];
            break;
        case kProximitySalamanderLeft:
            obstacle = [Salamander salamanderWithPos:pos type:type];
            break;            
        case kFlyingRock:            
            obstacle = [FlyingRock rockWithPos:pos];
            break;            
        // Bosses
        case kDummyBoss:
            obstacle = [DummyBoss dummyBossWithPos:pos];
            break;
        case kBossTurtle:
            obstacle = [BossTurtle bossTurtleWithPos:pos];            
            break;
        case kBirdBoss:
            add = NO;
            break;
        case kWhaleBoss:
            add = NO;            
            break;
        case kBatBoss:
            add = NO;            
            break;
        case kAlienBossTurtle:
            add = NO;            
            break;    
        case kCatBoss:
            add = NO;            
            break;
        // Collectables/Helpers         
        case kAngel:
            obstacle = [Angel angelWithPos:pos];
            break;             
        case kBoost:
            obstacle = [Boost boostWithPos:pos];    
            break;
        case kFuel:
            obstacle = [Fuel fuelWithPos:pos];            
            break;     
        case kBombCat:
            obstacle = [BombCat bombCatWithPos:pos];
            break;
        case kCat:
            obstacle = [Cat catWithPos:pos];            
            break;
        case kCatBundle:
            obstacle = [CatBundle catBundleWithPos:pos];              
            break;
        // Helper objects
        //case kRedEgg:
        //case kBlueEgg: 
        //case kFlame:
        case kPlasmaBall:
            obstacle = [PlasmaBall plasmaBallWithPos:pos];
            break;            
        // Swarm versions ob obstacles
        case kSwarmTurtling:
            obstacle = [Turtling swarmTurtlingWithPos:pos];
            break;
        case kSwarmYellowBird:
            obstacle = [YellowBird swarmYellowBirdWithPos:pos];
            break;
        case kSwarmBlueBird:
            obstacle = [BlueBird swarmBlueBirdWithPos:pos];                        
            break;
        case kSwarmBlueFish:
            obstacle = [BlueFish swarmBlueFishWithPos:pos];                        
            break;
        case kSwarmBat:
            obstacle = [Bat swarmBatWithPos:pos];            
            break;
        default:
            add = NO;
            NSLog(@"Invalid obstacle number");
            //NSAssert(NO, @"Invalid obstacle number selected");
            break;
    }
    
    if (add) {
        [self addObstacle:obstacle]; 
        [delegate_ obstacleAdded:obstacle];
    }
}

- (void) addObstacle:(Obstacle *)obstacle
{
    [self addChild:obstacle z:kObstacleDepth];
    [obstacles_ addObject:obstacle];     
}

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos
{
    [combo_ enemyKilled:type pos:pos];
    
    // Check if a boss was killed
    if ([UtilFuncs isBoss:type]) {
        [self win];
    }
}

- (void) fireCat:(CatType)type
{
    if (!onGround_ && !inputLocked_) {        
        
        CatBullet *bullet = nil;        
        
        switch (type) {
            case kCatNormal:
#if !DEBUG_UNLIMITED_CATS                        
                if (numCats01_ > 0) {
#endif
                    numCats01_--;
                    [[GameManager gameManager] setNumCats01:numCats01_]; 
                    bullet = [CatBullet catBulletWithPos:rocket_.position withSpeed:(physics_.rocketSpeed + 10)];      
#if !DEBUG_UNLIMITED_CATS                        
                }
#endif                
                break;
            case kCatBomb:
#if !DEBUG_UNLIMITED_CATS                    
                if (numCats02_ > 0) {
#endif
                    numCats02_--;                    
                    [[GameManager gameManager] setNumCats02:numCats02_]; 
                    bullet = [CatBullet fatBulletWithPos:rocket_.position withSpeed:(physics_.rocketSpeed + 10)];                
#if !DEBUG_UNLIMITED_CATS                        
                }
#endif
                break;
            case kCatPierce:
#if !DEBUG_UNLIMITED_CATS                    
                if (numCats01_ > 0) {
#endif
                    numCats01_--;
                    [[GameManager gameManager] setNumCats01:numCats01_]; 
                    bullet = [CatBullet longBulletWithPos:rocket_.position withSpeed:(physics_.rocketSpeed + 10)];                
#if !DEBUG_UNLIMITED_CATS                        
                }
#endif
                break;
            default:
                break;
        }
        
        // Add the cat
        [self addChild:bullet z:kBulletDepth];
        [firedCats_ addObject:bullet];
        [[AudioManager audioManager] playSound:kMeow];        
    }
}

- (void) boostDisengaged:(BoostType)boostType
{
    [rocket_ toggleBoostOn:NO];
    
    switch (boostType) {
        // Take-off complete
        case kStartBoost:
            onGround_ = NO;    
            inputLocked_ = NO;     
            [rocket_ showFlying];
            break;
        default:
            break;
    }
}

- (void) useBoost
{
    if (!inputLocked_) {
        // The first time the player pressed the boost button
        if (onGround_) {
            inputLocked_ = YES;
            [physics_ engageBoost:kStartBoost];
            [rocket_ toggleBoostOn:YES];        
            
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
                // Don't allow boosts during invincibility boost
                if (!(physics_.boostOn && physics_.boostType == kInvincibilityBoost)) {
                    numBoosts_--;
                    
                    if (physics_.boostOn && (physics_.boostType == kRingBoost || physics_.boostType == kBoosterBoost)) {
                        [physics_ engageBoost:kInvincibilityBoost];
                        [rocket_ toggleBoostOn:YES];                            
                        [rocket_ showAuraForDuration:3.0f];      
                        NSString *comboName = (arc4random() % 2) ? R_MOJO_BOOST_BANNER : R_ROCKET_TIME_BANNER;
                        [[GameManager gameManager] showCombo:comboName];
                    }
                    else {
                        [physics_ engageBoost:kBoosterBoost];              
                        [rocket_ toggleBoostOn:YES];                            
                    }
                    /////////////////
                    
                    [[GameManager gameManager] setNumBoosts:numBoosts_];
                    [self showText:kSpeedUp];                
                }
#if !DEBUG_UNLIMITED_BOOSTS                
            }
#endif
        }
    }
}

- (void) slowPressed
{
    [physics_ rocketSlowed];
}

- (void) slowReleased
{
    [physics_ rocketSlowReleased];    
}

- (void) useSlow
{
    // Cannot use slow while collided, slowed, or in any form of boosting
    if (physics_.rocketMode == kNormal) {
        [physics_ rocketSlowed];
        [rocket_ showSlow];
    }
}

- (void) rocketCollision
{
#if DEBUG_CONSTANTSPEED || DEBUG_NOSLOWDOWN
    return;
#endif
    
    [physics_ rocketCollision];
    [self showText:kSpeedDown];    
}

- (void) powerUpCollected:(ObstacleType)type
{
    switch (type) {
        case kBoost:
            // Don't allow boosts during invincibility boost
            if (!(physics_.boostOn && physics_.boostType == kInvincibilityBoost)) {            
                [self showText:kSpeedUp];                    
                [[AudioManager audioManager] playSound:kKerrum];                                      
                [physics_ engageBoost:kRingBoost];
                [rocket_ toggleBoostOn:YES];                    
            }
            break;
        case kFuel:
            numBoosts_++;
            [[GameManager gameManager] setNumBoosts:numBoosts_];
            [self showText:kBoostPlus];   
            [[AudioManager audioManager] playSound:kPowerup];            
            break;
        case kCat:
            numCats01_++;
            [[GameManager gameManager] setNumCats01:numCats01_];
            [self showText:kCatPlus];
            [[AudioManager audioManager] playSound:kCollectMeow];              
            break;
        case kBombCat:
            numCats02_++;
            [[GameManager gameManager] setNumCats02:numCats02_];
            [self showText:kCatPlus];
            [[AudioManager audioManager] playSound:kCollectMeow];              
            break;
        case kCatBundle:
            // TODO
            break;
        default:
            break;
    }
}

- (void) showText:(ActionText)actionText
{
    EventText *text = [EventText eventText:actionText];
    [rocket_ addChild:text z:kLabelDepth];
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
