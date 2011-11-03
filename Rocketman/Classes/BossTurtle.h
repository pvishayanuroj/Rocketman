//
//  BossTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "SideMovementDelegate.h"
#import "BoundaryDelegate.h"

enum {
    kHeadBoundary,
    kBodyBoundary
};

@class Boundary;
@class SideMovement;

@interface BossTurtle : Obstacle <SideMovementDelegate, BoundaryDelegate> {
    
    CCAction *damageAnimation_;
    
    Boundary *headBoundary_;
    
    Boundary *bodyBoundary_;
    
    CGPoint headOffset_;
    
    CCParticleSystem *engineFlame_;            
    
    NSUInteger numShells_;
    
    NSUInteger maxShells_;
    
    NSInteger HP_;
    
    CGFloat yTarget_;
    
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

+ (void) resetID;

@end
