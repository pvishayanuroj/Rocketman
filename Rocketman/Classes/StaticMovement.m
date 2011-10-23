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

+ (id) staticMovement
{
    return [[[self alloc] initStaticMovement:1.0f] autorelease];
}

+ (id) staticMovement:(CGFloat)rate
{
    return [[[self alloc] initStaticMovement:rate] autorelease];    
}

- (id) initStaticMovement:(CGFloat)rate
{
    if ((self = [super initMovement])) {
        
        rate_ = rate;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) move:(CGFloat)speed obstacle:(Obstacle *)obstacle
{
    CGPoint p = CGPointMake(0, -speed * rate_);
    obstacle.position = ccpAdd(obstacle.position, p);    
}

@end
