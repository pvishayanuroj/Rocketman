//
//  SideMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SideMovement.h"
#import "GameObject.h"
#import "GameManager.h"
#import "Rocket.h"

@implementation SideMovement

@synthesize leftCutoff = leftCutoff_;
@synthesize rightCutoff = rightCutoff_;
@synthesize speed = speed_;
@synthesize movingLeft = movingLeft_;
@synthesize delegate = delegate_;

+ (id) sideMovement:(GameObject *)object distance:(CGFloat)distance speed:(CGFloat)speed
{
    CGFloat leftCutoff = object.position.x - distance * 0.5f;
    CGFloat rightCutoff = leftCutoff + distance;
    return [[[self alloc] initSideMovement:leftCutoff rightCutoff:rightCutoff speed:speed] autorelease];
}

+ (id) sideMovement:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed
{
    return [[[self alloc] initSideMovement:leftCutoff rightCutoff:rightCutoff speed:speed] autorelease];
}

- (id) initSideMovement:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed
{
    if ((self = [super initMovement])) {
        
        sideSpeed_ = speed;
        leftCutoff_ = leftCutoff;
        rightCutoff_ = rightCutoff;
        delegate_ = nil;
        movingLeft_ = YES;
        
        proximityTriggerOn_ = NO;
        proximityTriggered_ = NO;
        randomTriggerOn_ = NO;
        
        rocket_ = nil;
    }
    return self;
}

- (void) dealloc
{    
    [rocket_ release];
    delegate_ = nil;
    
    [super dealloc];
}

- (id) copyWithZone: (NSZone *)zone
{
    SideMovement *cpy = [[SideMovement allocWithZone:zone] initSideMovement:self.leftCutoff rightCutoff:self.rightCutoff speed:self.speed];
    cpy.movingLeft = self.movingLeft;
    return cpy;
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    CGFloat dx;
    
    if (movingLeft_) {
        // Check if we got to the turnaround point to move right again
        if (object.position.x < leftCutoff_) {
            // Reset flags
            movingLeft_ = NO;
            proximityTriggered_ = NO;
            
            // Alert the delegate (if any)
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementLeftTurnaround:)]) {
                [delegate_ sideMovementLeftTurnaround:self];
            }
            
            dx = sideSpeed_;
        }
        else {
            dx = -sideSpeed_;
        }
    }
    else {
        // Check if we got to the turnaround point to move left
        if (object.position.x > rightCutoff_) {
            movingLeft_ = YES;
            proximityTriggered_ = NO;            
            
            // Alert the delegate (if any)
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementRightTurnaround:)]) {
                [delegate_ sideMovementRightTurnaround:self];
            }            
            
            dx = -sideSpeed_;            
        }
        else {
            dx = sideSpeed_;
        }
    }    
    
    CGPoint p = CGPointMake(dx, 0);     
    object.position = ccpAdd(object.position, p);    
    
    // Check for proximity triggering
    if (proximityTriggerOn_) {
        if (!proximityTriggered_) {
            CGFloat distance = rocket_.position.x - object.position.x;
            if (fabs(distance) < proximityDistance_) {
                proximityTriggered_ = YES;
                // Alert the delegate (if any) of the proximity trigger firing
                if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementProximityTrigger:)]) {
                    [delegate_ sideMovementProximityTrigger:self];
                }
            }
        }
    }
}

- (void) setProximityTrigger:(CGFloat)distance
{
    proximityTriggerOn_ = YES;
    proximityDistance_ = distance;
    
    // Hold a reference to the rocket
    [rocket_ release];
    rocket_ = [[[GameManager gameManager] rocket] retain];    
}

- (void) setRandomTrigger:(NSUInteger)numPerTurn
{
    
}

- (void) changeSideSpeed:(CGFloat)sideSpeed
{
    sideSpeed_ = sideSpeed;
}

@end
