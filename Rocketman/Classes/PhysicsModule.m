//
//  PhysicsModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PhysicsModule.h"


@implementation PhysicsModule

// Speed thresholds
const CGFloat V_CRUISE  = 9.5f;
const CGFloat V_SLOW    = 7.5f;
const CGFloat V_MAX     = 13.0f;
// Delta V based on threshold
const CGFloat DV_CRUISE = 0.001f;
const CGFloat DV_SLOW   = 0.002f;
const CGFloat DV_MAX    = 0.01f;

// Boost amount for most cases
const CGFloat VB_NORMAL         = 3.0f;
// Rate of boost change for the starting boost
const CGFloat DB_STARTBOOST     = 0.0005f;
// How much speed is added from a ring
const CGFloat DV_RINGBOOST      = 3.0f;

// Boost duration based on type
const CGFloat TB_BOOSTER        = 1.5f;
const CGFloat TB_INVINCIBILITY  = 3.0f;
const CGFloat TB_RING           = 1.5f;

// Game frame rate
const CGFloat SRSM_FPS = 60.0f;

@synthesize rocketSpeed = vR_;
@synthesize boostOn = boostOn_;
@synthesize boostType = boostType_;
@synthesize delegate = delegate_;

+ (id) physicsModule
{
    return [[[self alloc] initPhysicsModule] autorelease];
}

- (id) initPhysicsModule
{
    if ((self = [super init])) {
        
        vR_ = 0.0f;
        vB_ = 0.0f;
        rocketStopped_ = YES;
        boostOn_ = NO;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) step:(ccTime)dt
{
    if (!rocketStopped_) {
        if (boostOn_) {
            [self applyBoost:dt];
        }
        else {
            [self calculateSpeed:dt];
        }
    }
}

- (void) calculateSpeed:(ccTime)dt
{
#if DEBUG_CONSTANTSPEED
    return;
#endif
    
    // Decrease from full boost to cruising speed
    if (vR_ > V_CRUISE) {
        vR_ -= DV_MAX;
    }
    else if (vR_ > V_SLOW) {
        vR_ -= DV_CRUISE;
    }
    else {
        vR_ -= DV_SLOW;
    }
}

- (void) applyBoost:(ccTime)dt
{    
    // Apply boost rate of change
    vB_ += dB_;    
    
    // Apply boost, make sure max speed is not exceeded
    vR_ += vB_;
    if (vR_ > V_MAX) {
        vR_ = V_MAX;
    }
    if (vR_ > boostTarget_) {
        vR_ = boostTarget_;
    }
 
    switch (boostMode_) {
        case kTimedBoost:
            // Decrement time
            boostTimer_ -= dt;
            // Check if boost has completed
            if (boostTimer_ <= 0) {
                boostOn_ = NO;
                [delegate_ boostDisengaged:boostType_];
            }
            break;
        case kTargetBoost:
            // Check if target speed has been reached
            if (vR_ >= boostTarget_) {
                boostOn_ = NO;
                [delegate_ boostDisengaged:boostType_];                
            }
            break;
        default:
            break;
    }
}

- (void) engageBoost:(BoostType)boostType
{
    boostOn_ = YES;
    boostType_ = boostType;
    rocketStopped_ = NO;
    
    switch (boostType) {
        case kStartBoost:
            boostMode_ = kTargetBoost;
            boostTarget_ = V_CRUISE;
            vB_ = 0.0f;
            dB_ = DB_STARTBOOST;
            break;
        case kBoosterBoost:
            boostMode_ = kTimedBoost;
            boostTarget_ = V_MAX;
            boostTimer_ = TB_BOOSTER;
            vB_ = VB_NORMAL;
            dB_ = 0.0f;
            break;
        case kRingBoost:
            boostMode_ = kTimedBoost;
            boostTarget_ = vR_ + DV_RINGBOOST;
            boostTimer_ = TB_RING;
            vB_ = VB_NORMAL;
            dB_ = 0.0f;
            break;
        case kAngelBoost:
            break;
        case kInvincibilityBoost:
            boostMode_ = kTimedBoost;
            boostTarget_ = V_MAX;
            boostTimer_ = TB_INVINCIBILITY;
            vB_ = VB_NORMAL;
            dB_ = 0.0f;            
            break;
        default:
            break;
    }
}

@end
