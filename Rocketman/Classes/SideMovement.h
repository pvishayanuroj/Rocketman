//
//  SideMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"
#import "SideMovementDelegate.h"

@class Rocket;

@interface SideMovement : Movement {

    /** Current direction of movement */
    BOOL movingLeft_;
    
    /** This trigger fires once per turn if this obstacle is a certain x-distance away from the rocket */
    BOOL proximityTriggerOn_;
    
    /** This trigger fires up to a set number of times per turn */
    BOOL randomTriggerOn_;
    
    /** Whether or not the proximity trigger has fired this turn */
    BOOL proximityTriggered_;
    
    /** Movement speed */
    CGFloat sideSpeed_;
    
    /** The left turnaround point */        
    CGFloat leftCutoff_;

    /** The right turnaround point */    
    CGFloat rightCutoff_;    
    
    /** How close the x-distance must be for the proximity trigger to fire */
    CGFloat proximityDistance_;
    
    /** How many times this fires per direction/turn */
    NSUInteger numRandomTriggers_;
    
    /** Delegate object */
    id <SideMovementDelegate> delegate_;            
    
    /** Reference to the player rocket */
    Rocket *rocket_;
    
}

@property (nonatomic, assign) id <SideMovementDelegate> delegate;

+ (id) sideMovement:(Obstacle *)obstacle distance:(CGFloat)distance speed:(CGFloat)speed;

+ (id) sideMovement:(Obstacle *)obstacle leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed;

- (id) initSideMovement:(Obstacle *)obstacle leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed;

- (void) changeSideSpeed:(CGFloat)sideSpeed;

- (void) setProximityTrigger:(CGFloat)distance;

- (void) setRandomTrigger:(NSUInteger)numPerTurn;

@end
