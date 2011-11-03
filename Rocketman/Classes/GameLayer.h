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

@class Rocket;
@class Cat;
@class Boost;
@class Fuel;
@class Obstacle;
@class Doodad;
@class CDAudioManager;
@class CDSoundEngine;

@interface GameLayer : CCLayer <UIAccelerometerDelegate> {
 
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
 
    /** Holds all current active obstacles */
    NSMutableArray *obstacles_;
    
    /** Holds all current active cats */
    NSMutableArray *firedCats_;

    /** Holds all current active doodads */
    NSMutableArray *doodads_;   
    
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
    
    BOOL boostEngaged_;
    
    BOOL onGround_;
    
    BOOL inputLocked_;
    
    BOOL lossTriggered_;
    
    CGFloat nextCloudHeight_;
    
    CGFloat nextSlowCloudHeight_;
    
    CGFloat height_;
    
    CGFloat maxHeight_;
    
    CGFloat lossHeight_;
    
    CGFloat v0_;    
    
    CGFloat v_;
    
    CGFloat dv_;
    
    CGFloat ddv_;
    
    CGFloat vMax_;
    
    CGFloat vBoost_;
    
    CGFloat vBoostRing_;
    
    CGFloat boost_;    
    
    CGFloat boostRate_;
    
    CGFloat boostTarget_;
    
    CGFloat boostTimer_;
    
    CGFloat dt_;
    
    NSInteger ammoType_;
}

@property (nonatomic, assign) id delegate;

+ (id) startWithLevelData:(NSDictionary *)data;

- (id) initWithLevelData:(NSDictionary *)data;

- (void) cloudGenerator;

/** Method called in a loop to read from object data dictionary and add obstacles */
- (void) obstacleGenerator;

- (void) physicsStep:(ccTime)dt;

- (void) applyBoost:(ccTime)dt;

/** Method called in a loop to move non-player objects */
- (void) applyGravity;

- (void) updateCounters;

/** Method called in a loop to handle collisions */
- (void) collisionDetect;

- (void) moveRocketHorizontally;

- (NSInteger) getRandomX;

- (void) loss;

- (void) addBirdSwarm:(NSInteger)size;

- (void) addTurtlingSwarm:(NSInteger)size;

- (void) addDoodad:(DoodadType)type pos:(CGPoint)pos;

- (void) addDoodad:(Doodad *)doodad;

- (void) addObstacle:(ObstacleType)type pos:(CGPoint)pos;

- (void) addObstacle:(Obstacle *)obstacle;

- (void) fireCat01;

- (void) fireCat02;

- (void) takeOffComplete;

- (void) useBoost;

- (void) engageBoost:(CGFloat)speedup amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time;

- (void) engageFixedBoost:(CGFloat)speed amt:(CGFloat)amt rate:(CGFloat)rate time:(CGFloat)time;

- (void) slowDown:(CGFloat)factor;

- (void) powerUpCollected:(ObstacleType)type;

- (void) showText:(EventText)event;

- (void) removeText:(id)node data:(CCSprite *)text;

@end
