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
    
    CGFloat radius_;
    
    CGFloat radiusSquared_;
    
    BOOL collided_;
}

@property (nonatomic, readonly) CGFloat radiusSquared;
@property (nonatomic, readonly) BOOL collided;

- (void) fall:(CGFloat)speed;

- (void) hit;

- (void) collide;

- (void) destroy;

@end
