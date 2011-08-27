//
//  AlienHoverTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"
#import "SideMovementDelegate.h"

@class SideMovement;
@class Boundary;

@interface AlienHoverTurtle : Obstacle <SideMovementDelegate> {
    
    CCAction *damageAnimation_;
    
    CCAction *attackAnimation_;    
    
    NSInteger HP_;
    
    Boundary *boundary_;
}

+ (id) alienHoverTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showAttack;

- (void) showDamage;

- (void) sideMovementProximityTrigger:(SideMovement *)movement;

- (void) sideMovementRandomTrigger:(SideMovement *)movement;

@end
