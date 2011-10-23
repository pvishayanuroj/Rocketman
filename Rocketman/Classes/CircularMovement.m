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

+ (id) circularMovement:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;
{
    return [[[self alloc] initCircularMovement:rate radius:radius angle:angle] autorelease];    
}

- (id) initCircularMovement:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;
{
    if ((self = [super initMovement])) {
        
        time_ = angle;
        rate_ = rate;
        radius_ = radius;
        previous_ = origin_;
        
    }
    return self;
}

- (void) move:(CGFloat)speed obstacle:(Obstacle *)obstacle
{
    time_ += rate_;
    
    if (time_ > TWO_PI) {
        time_ -= TWO_PI;
    }
    
    CGPoint moved = ccpSub(obstacle.position, previous_);
    
    origin_ = ccpAdd(origin_, moved);
    
    CGPoint point = [self getPoint];
    
    // Determine the position of the obstacle
    obstacle.position = ccpAdd(origin_, point);
    previous_ = obstacle.position;
    
}

- (CGPoint) getPoint
{
    CGPoint p;
    p.x = radius_ * cos(time_);
    p.y = radius_ * sin(time_);
    return p;
}

@end
