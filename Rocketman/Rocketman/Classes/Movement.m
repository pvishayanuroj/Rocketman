//
//  Movement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"
#import "Obstacle.h"

@implementation Movement

- (id) initWithObstacle:(Obstacle *)obstacle
{
    if ((self = [super init])) {
        
        obstacle_ = [obstacle retain];
        
    }
    return self;
}

- (void) dealloc
{
    [obstacle_ release];

    [super dealloc];
}

- (void) move:(CGFloat)speed
{
    NSAssert(NO, @"Move needs to be implemented in the child class");
}

@end
