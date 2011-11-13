//
//  Salamander.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"
#import "FlameDelegate.h"

@class Flame;

@interface Salamander : Obstacle <BoundaryDelegate, FlameDelegate> {
 
    CGFloat cooldown_;
    
    Flame *flame_;
    
    CCAction *attackAnimation_;    
}

+ (id) salamanderWithPos:(CGPoint)pos type:(ObstacleType)type;

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
