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

+ (id) constantMovement:(CGPoint)rate
{
    return [[[self alloc] initConstantMovement:rate] autorelease];    
}

+ (id) constantMovementDown:(CGFloat)rate
{
    return [[[self alloc] initConstantMovement:CGPointMake(0, -rate)] autorelease];    
}

- (id) initConstantMovement:(CGPoint)rate
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
    obstacle.position = ccpAdd(obstacle.position, rate_);    
}


@end
