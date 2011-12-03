//
//  Structs.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

/** Structure used to hold information about the bounding shape used for collision detection */    
typedef struct {
    
	/** Whether or not the object can be hit (shot) */    
    BOOL hitActive;

    /** Whether or not the rocket can collide with the object */
    BOOL collideActive;
    
    /** If true, boundary will automatically become inactive when hit or collided with */
    BOOL autoInactive;    
    
    /** Whether or not this object's collision boundary is circular or rectangular */
    BOOL circular;

    /** If the collision boundary is circular, this is the radius used */    
    CGFloat radius;

    /** If the collision boundary is rectangular, this is the size of the box */    
    CGSize size;  

    /** The offset of the center of the bounding shape from the position of the object */    
    CGPoint offset;
    
} PVCollide;

/** Structure used to hold all final score information */
typedef struct {
    
    /** Time spent on stage */
    double elapsedTime;
    
    CGFloat totalHeight;
    
    double totalSlowTime;
    
    NSInteger maxCombo;
    
    /** Number of rocket collisions */
    NSInteger numCollisions;
    
    NSInteger numEnemiesKilled;
    
    NSInteger numBoostCombos;
    
    NSInteger numSupercatCombos;
    
    NSInteger numBombsCollected;    
    
    NSInteger numCatBundlesCollected;
    
    NSInteger numCatsCollected;
    
    NSInteger numBoostsCollected;
    
    NSInteger numFuelCollected;
    
    NSInteger numCatsFired;
    
    NSInteger numBombsFired;
    
    NSInteger numBoostsUsed;
    
} SRSMScore;