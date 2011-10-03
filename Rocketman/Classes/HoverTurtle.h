//
//  HoverTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "SideMovementDelegate.h"

@class SideMovement;

@interface HoverTurtle : Obstacle <SideMovementDelegate> {
    
}

+ (id) hoverTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) initEngine;

- (void) sideMovementProximityTrigger:(SideMovement *)movement;

- (void) sideMovementRandomTrigger:(SideMovement *)movement;

@end
