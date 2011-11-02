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
#import "BoundaryDelegate.h"

@interface HoverTurtle : Obstacle <BoundaryDelegate, SideMovementDelegate> {
    
}

+ (id) hoverTurtleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) initEngine;

- (void) death;

+ (void) resetID;

@end
