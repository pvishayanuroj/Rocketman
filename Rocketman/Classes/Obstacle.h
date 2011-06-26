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
    
    PVCollide collision_;
    
    BOOL collided_;
    
    BOOL shootable_;
    
    CCAction *destroyAnimation_;   
    
	NSUInteger unitID_;    
}

@property (nonatomic, readonly) PVCollide collision;
@property (nonatomic, readonly) BOOL collided;
@property (nonatomic, readonly) BOOL shootable;

- (void) showDestroy:(EventText)text;

- (void) fall:(CGFloat)speed;

- (void) bulletHit;

- (void) collide;

- (void) destroy;

@end
