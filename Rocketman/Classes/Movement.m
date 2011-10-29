//
//  Movement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"
#import "Obstacle.h"

@implementation Movement

- (id) initMovement
{
    if ((self = [super init])) {
           
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    NSAssert(NO, @"Move needs to be implemented in the child class");
}

@end
