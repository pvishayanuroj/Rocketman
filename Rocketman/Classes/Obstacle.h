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

    NSMutableArray *boundaries_;
    
    Movement *movement_;
    
    PVCollide defaultPVCollide_;
    
	/** Stored idle animation for all obstacles*/
	CCAction *idleAnimation_;                 
    
    CCAction *destroyAnimation_;   
    
	NSUInteger unitID_;
    
    BOOL markToRemove_;
}

@property (nonatomic, assign) BOOL markToRemove;
@property (nonatomic, readonly) NSMutableArray *boundaries;

- (void) showIdle;

- (void) showDeath:(EventText)text;

- (void) fall:(CGFloat)speed;

- (void) bulletHit;

- (void) collide;

/** 
 * Destroys the obstacle. Note: This method MUST be called
 * for proper deallocation of this obstacle, because it resolves
 * circular references and removes this cocos node from the parent
 */
- (void) destroy;

@end
