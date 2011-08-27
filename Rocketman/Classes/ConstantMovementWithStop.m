//
//  ConstantMovementWithStop.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ConstantMovementWithStop.h"
#import "Obstacle.h"

@implementation ConstantMovementWithStop

+ (id) constantMovementWithStop:(Obstacle *)obstacle rate:(CGFloat)rate withStop:(CGFloat)height 
{
    return [[[self alloc] initConstantMovementWithStop:obstacle rate:rate height:height] autorelease];    
}

- (id) initConstantMovementWithStop:(Obstacle *)obstacle rate:(CGFloat)rate height:(CGFloat)height
{
    if ((self = [super initWithObstacle:obstacle])) {
        
        rate_ = rate;
        moving_ = YES;
        targetHeight_ = height;
        fallingDown_ = rate < 0;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) move:(CGFloat)speed
{
    if (moving_) {
        CGPoint p = CGPointMake(0, rate_);      
        // Going downwards
        if (fallingDown_) {
            // Check if target has been reached
            if (obstacle_.position.y < targetHeight_) {
                moving_ = NO;
                p.y = 0;
            }
        }
        // Going upwards
        else {
            // Check if target has been reached
            if (obstacle_.position.y > targetHeight_) {
                moving_ = NO;
                p.y = 0;
            }         
        }
        // Actual movement
        obstacle_.position = ccpAdd(obstacle_.position, p);                            
    }
}

@end
