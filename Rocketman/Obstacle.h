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
    
    CGFloat radiusSquared_;
    
}

@property CGFloat radiusSquared;

- (void) fall:(CGFloat)speed;

- (void) collide;

- (void) destroy;

@end
