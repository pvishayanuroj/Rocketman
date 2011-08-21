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
    return [[[self alloc] initStaticMovement:obstacle rate:1.0f] autorelease];
}

+ (id) staticMovement:(Obstacle *)obstacle rate:(CGFloat)rate
{
    return [[[self alloc] initStaticMovement:obstacle rate:rate] autorelease];    
}

- (id) initStaticMovement:(Obstacle *)obstacle rate:(CGFloat)rate
{
    if ((self = [super initWithObstacle:obstacle])) {
        
        rate_ = rate;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) move:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, -speed * rate_);
    obstacle_.position = ccpAdd(obstacle_.position, p);    
}

@end
