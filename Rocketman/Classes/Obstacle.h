//
//  Obstacle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface Obstacle : CCNode {
 
    CCSprite *sprite_;

    NSMutableArray *boundaries_;
    
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

- (void) destroy;

@end
