//
//  RelativeMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "RelativeMovement.h"
#import "GameObject.h"

@implementation RelativeMovement

@synthesize equalRate = equalRate_;
@synthesize fallRate = fallRate_;

+ (id) relativeMovement:(CGFloat)fallRate equalRate:(CGFloat)equalRate
{
    return [[[self alloc] initRelativeMovement:fallRate equalRate:equalRate] autorelease];
}

- (id) initRelativeMovement:(CGFloat)fallRate equalRate:(CGFloat)equalRate
{
    if ((self = [self initMovement])) {
        
        equalRate_ = equalRate;
        relativeFactor_ = (equalRate - fallRate)/equalRate;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) copyWithZone: (NSZone *)zone
{
    RelativeMovement *cpy = [[RelativeMovement allocWithZone:zone] initRelativeMovement:self.fallRate equalRate:self.equalRate];
    return cpy;
} 

- (void) move:(CGFloat)speed object:(GameObject *)object
{
    CGFloat delta = (speed - equalRate_) * relativeFactor_;
    CGPoint p = CGPointMake(0, equalRate_ + delta);
    //NSLog(@"speed: %4.2f, objspeed: %4.2f", speed, p.y);
    object.position = ccpSub(object.position, p);     
}

@end
