//
//  Turtling.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Turtling : Obstacle <BoundaryDelegate> {
    
    ObstacleType origType_;    
    
}

+ (id) turtlingWithPos:(CGPoint)pos;

+ (id) swarmTurtlingWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
