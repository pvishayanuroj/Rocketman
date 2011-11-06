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
const CGFloat V_T1      = 7.5f;
const CGFloat V_T2      = 5.0f;
const CGFloat V_MIN     = 2.0f; // Collisions will not cause speed to go any slower
const CGFloat V_MAX     = 13.0f;
// Delta V based on threshold
const CGFloat DV_MAX    = 0.01f;
const CGFloat DV_CRUISE = 0.001f;
const CGFloat DV_T1     = 0.0025f;
const CGFloat DV_T2     = 0.005f;
const CGFloat DV_MIN    = 0.005f;
const CGFloat DDV_MIN   = 0.0006f;

// Speed when slowed by a collision
const CGFloat V_COLLIDE = 1.5f;
// Speed slowdown for collisions
const CGFloat DV_COLLIDE = 1.5f;
// Slow duration for collisions
const CGFloat TS_COLLIDE = 0.8f;

// Speed change when slowed by slow button
const CGFloat DV_SLOWED = 4.0f;
// Slow duration for slow button
const CGFloat TS_SLOWED = 2.0f;

// Rate of speed change when restoring the original speed from a slow or collision
const CGFloat DV_SLOWED_RESTORE = 0.1f;
const CGFloat DV_COLLIDE_RESTORE = 0.25f;

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
@synthesize rocketMode = rocketMode_;
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
        dVMin_ = 0.0f;
        rocketMode_ = kStopped;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) step:(ccTime)dt
{
    switch (rocketMode_) {
        case kNormal:
            [self calculateSpeed:dt];
            break;
        case kBoosting:
            [self applyBoost:dt];
            break;
        case kSlowed:
        case kCollided:
            [self applySlow:dt];
            break;
        default:
            break;
    }
}

- (void) calculateSpeed:(ccTime)dt
{
#if DEBUG_CONSTANTSPEED
    return;
#endif
    if (vR_ > DV_MIN) {
        dVMin_ = 0;
    }
    
    // Decrease from full boost to cruising speed
    if (vR_ > V_CRUISE) {
        vR_ -= DV_MAX;
    }
    else if (vR_ > V_T1) {
        vR_ -= DV_CRUISE;
    }
    else if (vR_ > V_T2) {
        vR_ -= DV_T1;
    }
    else if (vR_ > V_MIN) {
        vR_ -= DV_T2;
    }
    else {
        vR_ -= (DV_MIN + dVMin_);
        dVMin_ += DDV_MIN;
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
                rocketMode_ = kNormal;
                [delegate_ boostDisengaged:boostType_];
            }
            break;
        case kTargetBoost:
            // Check if target speed has been reached
            if (vR_ >= boostTarget_) {
                rocketMode_ = kNormal;
                [delegate_ boostDisengaged:boostType_];                
            }
            break;
        default:
            break;
    }
}

- (void) applySlow:(ccTime)dt
{
    slowTimer_ -= dt;
    // Only increase speed back to normal after time has elapsed
    if (slowTimer_ <= 0) {
        vR_ += dRestore_;
        // Once original speed is reached, go back to normal mode
        if (vR_ >= origSpeed_) {
            vR_ = origSpeed_;
            rocketMode_ = kNormal;
        }
    }
}

- (void) rocketCollision
{
    // Special case, if speed under minimum, collisions have no effect
    if (vR_ < V_MIN) {
        return;
    }
    
    // If rocket is boosting, do not go through the whole slowing sequence,
    // just cut speed to cruising and halt boosting
    if (rocketMode_ == kBoosting) {
        rocketMode_ = kNormal;
        vR_ = V_CRUISE;
        [delegate_ boostDisengaged:boostType_];
    }
    // Colliding while slowed
    else if (rocketMode_ == kSlowed) {
        rocketMode_ = kCollided;
        origSpeed_ -= DV_COLLIDE;
        dRestore_ = DV_COLLIDE_RESTORE;
        vR_ = V_COLLIDE;
        slowTimer_ = TS_COLLIDE;        
    }
    // Colliding during another collision
    else if (rocketMode_ == kCollided) {
        rocketMode_ = kCollided;
        origSpeed_ = origSpeed_;
        dRestore_ = DV_COLLIDE_RESTORE;
        vR_ = V_COLLIDE;
        slowTimer_ = TS_COLLIDE;         
    }
    // Colliding while going up normally
    else {
        rocketMode_ = kCollided;
        origSpeed_ = vR_ - DV_COLLIDE;
        dRestore_ = DV_COLLIDE_RESTORE;
        vR_ = V_COLLIDE;
        slowTimer_ = TS_COLLIDE;
    }
}

- (void) rocketSlowed
{
    rocketMode_ = kSlowed;
    origSpeed_ = vR_;
    dRestore_ = DV_SLOWED_RESTORE;    
    vR_ -= DV_SLOWED;
    vR_ = (vR_ < 0) ? 0 : vR_;
    slowTimer_ = TS_SLOWED;
}

- (void) engageBoost:(BoostType)boostType
{
    rocketMode_ = kBoosting;
    boostType_ = boostType;
    
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
            boostTarget_ = (vR_ < V_MIN) ? V_CRUISE : vR_ + DV_RINGBOOST;
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

- (BOOL) boostOn
{
    return rocketMode_ == kBoosting;
}

- (BOOL) isSlowed
{
    return rocketMode_ == kSlowed || rocketMode_ == kCollided;
}

@end
