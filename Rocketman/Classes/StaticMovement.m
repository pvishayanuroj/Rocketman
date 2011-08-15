//
//  StaticMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StaticMovement.h"
#import "Obstacle.h"

@implementation StaticMovement

+ (id) staticMovement:(Obstacle *)obstacle
{
    return [[[self alloc] initStaticMovement:obstacle] autorelease];
}

- (id) initStaticMovement:(Obstacle *)obstacle
{
    if ((self = [super initWithObstacle:obstacle])) {
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) move:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed);
    obstacle_.position = ccpSub(obstacle_.position, p);    
}

@end
