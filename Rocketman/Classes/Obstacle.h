//
//  Obstacle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "Structs.h"
#import "GameObject.h"
#import "ObstacleDelegate.h"

@interface Obstacle : GameObject {

    /** The array of boundaries that an obstacle can have */
    NSMutableArray *boundaries_;
    
    /** 
     * Array of child obstacles that will move with this obstacle. 
     * Also, if this obstacle is destroyed, all the child obstacles are removed 
     */
    NSMutableArray *childObstacles_;
    
    /** 
     * A default collision structure to use as a template 
     * (See implementation for details about default settings)
     */
    PVCollide defaultPVCollide_;
    
	/** Stored idle animation for all obstacles */
	CCAction *idleAnimation_;                 
    
    /** Flag used in the Game Layer, indicating whether or not the object is destroyed */
    BOOL destroyed_;    
    
    /** The ID number of this obstacle, unique across obstacle types */
	NSUInteger unitID_;
    
    /** 
     * The type that the obstacle was originally created as. This changes because 
     * certain obstacles can be created/labeled differently, such as swarm versions, or boss versions
     */
    ObstacleType originalObstacleType_;
    
    /** The obstacle's common type */
    ObstacleType obstacleType_;
    
    /** The object's name */
    NSString *name_;
    
    /** Whether or not a signal will be sent when the set height is reached */
    BOOL heightTriggerActive_;
    
    /** Height at which to send a signal to the delegate */
    CGFloat triggerHeight_;
    
    /** Delegate object of this obstacle */
    id <ObstacleDelegate> delegate_;
}

@property (nonatomic, readonly) ObstacleType obstacleType;
@property (nonatomic, readonly) NSUInteger unitID;
@property (nonatomic, assign) BOOL destroyed;
@property (nonatomic, readonly) NSMutableArray *boundaries;

/** Runs the idle animation of the object */
- (void) showIdle;

/** Runs all movements associated with this object. Also moves all children as well */
- (void) fall:(CGFloat)speed;

/** 
 * Correctly destroys and the obstacle. Note: This method MUST be called
 * for proper deallocation of this obstacle, because it removes this cocos 
 * node from the parent and cleans up all child obstacles
 */
- (void) destroy;

/** Sets up a height trigger that when activated, signals the delegate */
- (void) setHeightTrigger:(CGFloat)height delegate:(id <ObstacleDelegate>)delegate;

@end
