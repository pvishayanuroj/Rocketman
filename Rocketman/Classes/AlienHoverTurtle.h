//
//  AlienHoverTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "SideMovementDelegate.h"
#import "BoundaryDelegate.h"

@class SideMovement;
@class Boundary;

@interface AlienHoverTurtle : Obstacle <BoundaryDelegate, SideMovementDelegate> {
    
    CCAction *damageAnimation_;
    
    CCAction *attackAnimation_;    
    
    NSInteger HP_;
    
    Boundary *boundary_;
    
    CGFloat yTarget_;
}

+ (id) shieldedAlienHoverTurtleWithPos:(CGPoint)pos;

+ (id) alienHoverTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type;

- (void) initActions;

- (void) showAttack;

- (void) showDamage;

- (void) death;

+ (void) resetID;

@end
