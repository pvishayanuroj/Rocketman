//
//  HoverTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"
#import "SideMovementDelegate.h"

@class SideMovement;

@interface HoverTurtle : Obstacle <SideMovementDelegate> {
    
    CGFloat yTarget_;    
    
}

+ (id) hoverTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) initEngine;

- (void) sideMovementRandomTrigger:(SideMovement *)movement;

@end
