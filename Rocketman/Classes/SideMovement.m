//
//  SideMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SideMovement.h"
#import "Obstacle.h"

@implementation SideMovement

@synthesize delegate = delegate_;

+ (id) sideMovement:(Obstacle *)obstacle leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed
{
    return [[[self alloc] initSideMovement:obstacle leftCutoff:leftCutoff rightCutoff:rightCutoff speed:speed] autorelease];
}

- (id) initSideMovement:(Obstacle *)obstacle leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed
{
    if ((self = [super initWithObstacle:obstacle])) {
        
        sideSpeed_ = speed;
        leftCutoff_ = leftCutoff;
        rightCutoff_ = rightCutoff;
        delegate_ = nil;
        movingLeft_ = YES;
        
    }
    return self;
}

- (void) dealloc
{
    delegate_ = nil;
    
    [super dealloc];
}

- (void) move:(CGFloat)speed
{
    CGFloat dx;
    
    if (movingLeft_) {
        // Check if we got to the turnaround point to move right again
        if (obstacle_.position.x < leftCutoff_) {
            movingLeft_ = NO;
            dx = sideSpeed_;
            
            // Alert the delegate (if any)
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementLeftTurnaround:)]) {
                [delegate_ sideMovementLeftTurnaround:self];
            }
        }
        else {
            dx = -sideSpeed_;
        }
    }
    else {
        // Check if we got to the turnaround point to move left
        if (obstacle_.position.x > rightCutoff_) {
            movingLeft_ = YES;
            dx = -sideSpeed_;
            
            // Alert the delegate (if any)
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementRightTurnaround:)]) {
                [delegate_ sideMovementRightTurnaround:self];
            }            
        }
        else {
            dx = sideSpeed_;
        }
    }    
    
    CGPoint p = CGPointMake(dx, 0);     
    obstacle_.position = ccpAdd(obstacle_.position, p);    
}

- (void) changeSideSpeed:(CGFloat)sideSpeed
{
    sideSpeed_ = sideSpeed;
}

@end
