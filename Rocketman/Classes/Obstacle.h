//
//  Obstacle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Movement;

@interface Obstacle : CCNode {
 
    CCSprite *sprite_;

    /** The array of boundaries that an obstacle can have */
    NSMutableArray *boundaries_;
    
    Movement *movement_;
    
    /** 
     * A default collision structure to use as a template 
     * (See implementation for details about default settings)
     */
    PVCollide defaultPVCollide_;
    
	/** Stored idle animation for all obstacles */
	CCAction *idleAnimation_;                 
    
    CCAction *destroyAnimation_;   
    
	NSUInteger unitID_;
    
    /** Flag used in the Game Layer, indicating whether or not the object is destroyed */
    BOOL destroyed_;
    
    /** The object's name */
    NSString *name_;
}

@property (nonatomic, assign) BOOL destroyed;
@property (nonatomic, readonly) NSMutableArray *boundaries;

/** Runs the idle animation of the object */
- (void) showIdle;

- (void) showDeath:(EventText)text;

- (void) fall:(CGFloat)speed;

- (void) bulletHit;

- (void) collide;

/** Just flags the object to eventually be destroyed */
- (void) flagToDestroy;

/** 
 * Correctly destroys and the obstacle. Note: This method MUST be called
 * for proper deallocation of this obstacle, because it resolves
 * circular references and removes this cocos node from the parent
 */
- (void) destroy;

@end
