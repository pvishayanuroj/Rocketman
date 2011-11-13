//
//  Flame.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"
#import "FlameDelegate.h"

@class Boundary;

@interface Flame : Obstacle <BoundaryDelegate> {
    
    CGFloat flameDuration_;
    
    CCFiniteTimeAction *startAnimation_;

    CCAction *flamingAnimation_;
    
    CCFiniteTimeAction *endAnimation_;    
    
    Boundary *boundary_;
    
    id <FlameDelegate> flameDelegate_;
}

@property (nonatomic, assign) id <FlameDelegate> flameDelegate;

+ (id) flameWithPos:(CGPoint)pos flameDirection:(FlameDirection)flameDirection flameDuration:(CGFloat)flameDuration;

+ (id) repeatingFlameWithPos:(CGPoint)pos flameDirection:(FlameDirection)flameDirection flameDuration:(CGFloat)flameDuration;

- (id) initWithPos:(CGPoint)pos flameDirection:(FlameDirection)flameDirection flameDuration:(CGFloat)flameDuration;

- (void) initAnimations;

- (void) initActions;

- (void) startFlame;

- (void) cutFlame;

- (void) enableCollision;

- (void) disableCollision;

+ (void) resetID;

@end
