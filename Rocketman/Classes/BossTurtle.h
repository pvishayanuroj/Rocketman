//
//  BossTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@class Boundary;

@interface BossTurtle : Obstacle {
    
    CCAction *damageAnimation_;
    
    Boundary *headBoundary_;
    
    Boundary *bodyBoundary_;
    
    CGPoint headOffset_;
    
    CCParticleSystem *engineFlame_;            
    
    BOOL movingLeft_;
    
    BOOL deployedShells_;
    
    NSUInteger numShells_;
    
    NSUInteger maxShells_;
    
    CGFloat leftCutoff_;
    
    CGFloat rightCutoff_;
    
    CGFloat yTarget_;
    
    NSInteger HP_;
    
}

+ (id) bossTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) initEngineFlame;

- (void) showDamage;

- (void) startShellSequence;

- (void) startDeathSequence;

- (void) deployShell;

- (void) addBlast;

- (void) engineFlameGoingRight:(BOOL)right;

@end
