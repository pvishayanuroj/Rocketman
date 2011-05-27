//
//  Obstacle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle

@synthesize radiusSquared = radiusSquared_;
@synthesize collided = collided_;

- (id) init
{
    if ((self = [super init])) {
     
        collided_ = NO;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed);
    self.position = ccpSub(self.position, p);    
}

- (void) hit
{
    NSAssert(NO, @"Hit must be implemented in the child class of Obstacle");    
}

- (void) collide
{
    collided_ = YES;
}

- (void) destroy
{
    
}

@end
