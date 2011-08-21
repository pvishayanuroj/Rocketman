//
//  ConstantMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ConstantMovement.h"
#import "Obstacle.h"

@implementation ConstantMovement

+ (id) constantMovement:(Obstacle *)obstacle rate:(CGFloat)rate
{
    return [[[self alloc] initConstantMovement:obstacle rate:rate] autorelease];    
}

- (id) initConstantMovement:(Obstacle *)obstacle rate:(CGFloat)rate
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
    CGPoint p = CGPointMake(0, rate_);
    obstacle_.position = ccpSub(obstacle_.position, p);    
}


@end
