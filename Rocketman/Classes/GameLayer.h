//
//  GameLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "CDAudioManager.h"
#import "GameLayerDelegate.h"
#import "PhysicsModuleDelegate.h"
#import "RocketDelegate.h"
#import "BannerDelegate.h"

@class Rocket;
@class PhysicsModule;
@class WallModule;
@class ComboModule;
@class StatsModule;
@class Gauge;
@class Cat;
@class Boost;
@class Fuel;
@class Obstacle;
@class Doodad;
@class CDAudioManager;
@class CDSoundEngine;

@interface GameLayer : CCLayer <PhysicsModuleDelegate, RocketDelegate, BannerDelegate, UIAccelerometerDelegate> {
 
    /** Maps object strings to object types */
    NSDictionary *objectNameMap_;
    
    /** Holds the map of where all objects are to be placed */
    NSDictionary *objectData_;
    
    /** Holds all row height triggers in sorted order */
    NSArray *objectDataKeys_;
    
    /** The current index of the next row height trigger */
    NSUInteger dataKeyIndex_;
    
    /** Next height at which there objects to add */
    NSInteger nextHeightTrigger_;
    
    /** Reference to the player rocket */
    Rocket *rocket_;
 
    /** Performs calculations regarding rocket speed */
    PhysicsModule *physics_;
    
    /** Used to generate the walls for certain levels */
    WallModule *wall_;
    
    /** Used to keep track of enemy kill combos */
    ComboModule *combo_;
    
    /** Used to keep track of all game statistics */
    StatsModule *stats_;    
    
    /** Graphical representation of rocket speed */
    Gauge *speedGauge_;
    
    /** Holds all current active obstacles */
    NSMutableArray *obstacles_;
    
    /** Holds all current active cats */
    NSMutableArray *firedCats_;

    /** Holds all current active doodads */
    NSMutableArray *doodads_;   
    
    /** Delegate object to notify of game layer events */
    id <GameLayerDelegate> delegate_;
    
    CGFloat rocketInitSpeed_;
    
    CGFloat rocketSpeed_;
    
    NSInteger screenWidth_;
    
    NSInteger screenHeight_;
    
    NSUInteger numBoosts_;
    
    NSUInteger numCats01_;
    
    NSUInteger numCats02_;
    
    CGFloat xCutoff_;
    
    CGFloat yCutoff_;
    
    NSInteger leftCutoff_;
    
    NSInteger rightCutoff_;

    CGFloat maxSideMoveSpeed_;
    
    CGFloat sideMoveSpeed_;
    
    CGFloat targetX_;
    
    CGFloat avg_[2];
    
    float accel[3];     
    
    BOOL onGround_;
    
    BOOL inputLocked_;
    
    BOOL lossTriggered_;
    
    CGFloat nextCloudHeight_;
    
    CGFloat nextSlowCloudHeight_;
    
    CGFloat height_;
    
    CGFloat maxHeight_;
    
    CGFloat lossHeight_;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, readonly) StatsModule *stats;

+ (id) startWithLevelData:(NSDictionary *)data;

- (id) initWithLevelData:(NSDictionary *)data;

- (void) cloudGenerator;

/** Method called in a loop to read from object data dictionary and add obstacles */
- (void) obstacleGenerator;

/** Method called in a loop to move non-player objects */
- (void) applyGravity;

- (void) updateCounters;

/** Method called in a loop to handle collisions */
- (void) collisionDetect;

/** Method called to affect rocket speed on collisions */
- (void) rocketCollision;

- (void) moveRocketHorizontally;

- (NSInteger) getRandomX;

/** Method used to trigger the sequence of events for a win */
- (void) win;

/** Method used to trigger the sequence of events for a loss */
- (void) loss;

- (void) addBirdSwarm:(NSInteger)size;

- (void) addTurtlingSwarm:(NSInteger)size;

- (void) addDoodad:(DoodadType)type pos:(CGPoint)pos;

- (void) addDoodad:(Doodad *)doodad;

- (void) addObstacle:(ObstacleType)type pos:(CGPoint)pos;

- (void) addObstacle:(Obstacle *)obstacle;

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos;

/** When a cat button is pressed */
- (void) fireCat:(CatType)type;

/** When the boost button is pressed */
- (void) useBoost;

/** Let's the physics module know that the slow button has been pressed */
- (void) slowPressed;

/** Let's the physics module know that the slow button has been released */
- (void) slowReleased;

- (void) powerUpCollected:(ObstacleType)type;

- (void) showText:(ActionText)actionText;

@end
