//
//  CircularMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CircularMovement.h"
#import "Obstacle.h"

@implementation CircularMovement

static const CGFloat TWO_PI = 2 * M_PI;

+ (id) circularMovement:(Obstacle *)obstacle rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;
{
    return [[[self alloc] initCircularMovement:obstacle rate:rate radius:radius angle:angle] autorelease];    
}

- (id) initCircularMovement:(Obstacle *)obstacle rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;
{
    if ((self = [super initWithObstacle:obstacle])) {
        
        time_ = angle;
        rate_ = rate;
        radius_ = radius;
        origin_ = obstacle_.position;
        previous_ = origin_;
        
    }
    return self;
}

- (void) move:(CGFloat)speed
{
    time_ += rate_;
    
    if (time_ > TWO_PI) {
        time_ -= TWO_PI;
    }
    
    CGPoint moved = ccpSub(obstacle_.position, previous_);
    
    origin_ = ccpAdd(origin_, moved);
    
    CGPoint point = [self getPoint];
    
    // Determine the position of the obstacle
    obstacle_.position = ccpAdd(origin_, point);
    previous_ = obstacle_.position;
    
}

- (CGPoint) getPoint
{
    CGPoint p;
    p.x = radius_ * cos(time_);
    p.y = radius_ * sin(time_);
    return p;
}

@end
