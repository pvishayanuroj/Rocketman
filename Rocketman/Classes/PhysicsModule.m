//
//  PhysicsModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PhysicsModule.h"
#import "GameManager.h"
#import "Rocket.h"

@implementation PhysicsModule

// Speed thresholds
const CGFloat V_CRUISE  = 9.5f;
const CGFloat V_T1      = 7.5f;
const CGFloat V_T2      = 5.0f;
const CGFloat V_MIN     = 2.0f; // Collisions will not cause speed to go any slower
const CGFloat V_MAX     = 13.0f;
// Delta V based on threshold
// Rate at which max speed decays (typically after boost)
const CGFloat DV_MAX    = 0.015f;
// Rate at which cruising speed decays
const CGFloat DV_CRUISE = 0.001f;
const CGFloat DV_T1     = 0.0025f;
const CGFloat DV_T2     = 0.005f;

const CGFloat DV_MIN    = 0.005f;
const CGFloat DDV_MIN   = 0.0008f;

// Speed slowdown for collisions
const CGFloat DV_COLLIDE = 2.0f;
// Duration immediately after a collision where the rocket's speed is not affected by other collisions
// Essentially a collision cooldown timer
const CGFloat TS_COLLIDE = 0.75f;

// Speed change when slowed by slow button
const CGFloat DV_SLOW_FACTOR = 0.5f;
// Rate at which the rocket recovers its speed after slowing down
const CGFloat DV_SLOWED_RESTORE = 0.3f;
// Slow will stop slowing at this speed
const CGFloat V_SLOW_MIN = 0.5f;

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
        collisionTimer_ = 0.0f;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) step:(ccTime)dt
{
    // Decrement timers
    if (collisionTimer_ > 0) {
        collisionTimer_ -= dt;
    }
    
    switch (rocketMode_) {
        case kNormal:
            [self calculateSpeed:dt];
            break;
        case kBoosting:
            [self applyBoost:dt];
            break;
        case kSlowed:
        case kSlowedRelease:
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

- (void) rocketCollision
{
    // Special case, if rocket had just collided, don't chain penalties
    if (collisionTimer_ > 0) {
        return;
    }
    
    // Special case, if speed under minimum, collisions have no effect
    if (vR_ < V_MIN) {
        return;
    }
    
    // Give a grace period before the next collision can happen
    collisionTimer_ = TS_COLLIDE;
    
    // If rocket is boosting, do not go through the whole slowing sequence,
    // just cut speed to cruising and halt boosting
    if (rocketMode_ == kBoosting) {
        rocketMode_ = kNormal;
        vR_ = V_CRUISE;
        [delegate_ boostDisengaged:boostType_];
    }
    // Colliding while slowed, cancel the slow
    else if (rocketMode_ == kSlowed) {
        rocketMode_ = kSlowedRelease;      
        origSpeed_ -= DV_COLLIDE;
        [[[GameManager gameManager] rocket] showWobbling];
        [[GameManager gameManager] invalidateSlowButton];          
    }
    // Colliding while speeding up from a slow
    else if (rocketMode_ == kSlowedRelease) {
        origSpeed_ -= DV_COLLIDE;
    }
    // Colliding while going up normally    
    else {
        rocketMode_ = kNormal;
        vR_ -= DV_COLLIDE;
    }
}

- (void) applySlow:(ccTime)dt
{
    if (rocketMode_ == kSlowed) {
        vR_ -= dS_;
        dS_ += 0.0005f;
        if (vR_ < V_SLOW_MIN) {
            vR_ = V_SLOW_MIN;
        }
    }
    else if (rocketMode_ == kSlowedRelease) {
        vR_ += dRestore_;
        if (vR_ >= origSpeed_) {
            vR_ = origSpeed_;
            rocketMode_ = kNormal;
        }        
    }
}

- (void) rocketSlowed
{
    if (vR_ < V_SLOW_MIN) {
        return;
    }
    
    // Cut boost if rocket is slowed during one
    if (rocketMode_ == kBoosting && boostType_ != kStartBoost) {
        [delegate_ boostDisengaged:boostType_];    
        rocketMode_ = kSlowed;
        origSpeed_ = V_CRUISE;
        dRestore_ = DV_SLOWED_RESTORE;
        vR_ *= DV_SLOW_FACTOR;
        dS_ = 0.001f;
        [[[GameManager gameManager] rocket] showSlow];        
    }
    else if (rocketMode_ == kNormal) {
        rocketMode_ = kSlowed;        
        origSpeed_ = vR_;
        dRestore_ = DV_SLOWED_RESTORE;
        vR_ *= DV_SLOW_FACTOR;
        dS_ = 0.001f;
        [[[GameManager gameManager] rocket] showSlow];
    }
}

- (void) rocketSlowReleased
{
    if (rocketMode_ == kSlowed) {
        rocketMode_ = kSlowedRelease;
        [[[GameManager gameManager] rocket] showFlying];
    }
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

@end
