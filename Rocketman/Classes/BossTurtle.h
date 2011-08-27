//
//  BossTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"
#import "SideMovementDelegate.h"

@class Boundary;
@class SideMovement;

@interface BossTurtle : Obstacle <SideMovementDelegate> {
    
    CCAction *damageAnimation_;
    
    Boundary *headBoundary_;
    
    Boundary *bodyBoundary_;
    
    CGPoint headOffset_;
    
    CCParticleSystem *engineFlame_;            
    
    NSUInteger numShells_;
    
    NSUInteger maxShells_;
    
    CGFloat yTarget_;
    
    NSInteger HP_;
    
    SideMovement *sideMovement_;
}

+ (id) bossTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) initEngineFlame;

- (void) showDamage;

- (void) startShellSequence;

- (void) startDeathSequence;

- (void) deployShell;

- (void) startFreeFall;

- (void) addBlast;

- (void) engineFlameGoingRight:(BOOL)right;

- (void) sideMovementLeftTurnaround:(SideMovement *)movement;

- (void) sideMovementRightTurnaround:(SideMovement *)movement;

- (void) sideMovementProximityTrigger:(SideMovement *)movement;

@end
