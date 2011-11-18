//
//  CircularMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CircularMovement.h"
#import "GameObject.h"

@implementation CircularMovement

static const CGFloat TWO_PI = 2 * M_PI;

@synthesize time = time_;
@synthesize rate = rate_;
@synthesize radius = radius_;
@synthesize origin = origin_;
@synthesize previous = previous_;

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

- (void) dealloc 
{
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    CircularMovement *cpy = [[CircularMovement allocWithZone:zone] initCircularMovement:self.rate radius:self.radius angle:self.time];
    return cpy;    
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    time_ += rate_;
    
    if (time_ > TWO_PI) {
        time_ -= TWO_PI;
    }
    
    CGPoint moved = ccpSub(object.position, previous_);
    
    origin_ = ccpAdd(origin_, moved);
    
    CGPoint point = [self getPoint];
    
    // Determine the position of the obstacle
    object.position = ccpAdd(origin_, point);
    previous_ = object.position;
    
}

- (CGPoint) getPoint
{
    CGPoint p;
    p.x = radius_ * cos(time_);
    p.y = radius_ * sin(time_);
    return p;
}

@end
