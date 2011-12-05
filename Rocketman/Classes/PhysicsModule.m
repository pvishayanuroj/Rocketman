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
static const CGFloat V_CRUISE  = 9.5f;
static const CGFloat V_T1      = 7.5f;
static const CGFloat V_T2      = 5.0f;
// At this speed, collisions will not cause speed to go any slower
// and slow will not decay beyond this speed. If slow is pressed below this speed, then no decay occurs
static const CGFloat V_MIN     = 2.0f; 
static const CGFloat V_MAX     = 13.0f;
// Delta V based on threshold
// Rate at which speeds within range from max to cruise decays (typically after boost)
static const CGFloat DV_MAX    = 0.015f;
// Rates for speed decay from cruise to T1, T1 to T2, and T2 to V_MIN
static const CGFloat DV_CRUISE = 0.001f;
static const CGFloat DV_T1     = 0.0025f;
static const CGFloat DV_T2     = 0.005f;

// Initial rate of fall once past V_MIN
static const CGFloat DV_MIN    = 0.005f;
// Rate of fall acceleration (gravity)
static const CGFloat DDV_MIN   = 0.0004f;

// Speed slowdown for collisions
static const CGFloat DV_COLLIDE = 2.0f;
// Duration immediately after a collision where the rocket's speed is not affected by other collisions
// Essentially a collision cooldown timer
static const CGFloat TS_COLLIDE = 0.5f;

// Speed change multiplier when slowed by slow button
static const CGFloat DV_SLOW_FACTOR = 0.5f;
// Rate at which rate of rocket slow increases
static const CGFloat DDV_SLOWED_RATE_GROWTH = 0.0005f;
// Slow will stop slowing at this speed
static const CGFloat V_SLOW_MIN = 0.0f;
// Rate at which original speed decays during a slow
static const CGFloat DV_SLOW_DECAY = 0.5f/60.0f;
// Minimum speed at which slow decay will stop at
static const CGFloat V_SLOW_DECAY_MIN = 2.0f;
// Rate at which the rocket recovers its speed after slowing down
static const CGFloat DV_SLOWED_RESTORE = 0.3f;

// Rate at which "world" slows to stop
static const CGFloat DV_WORLD_STOP = 0.1f;

// Boost amount for most cases
static const CGFloat VB_NORMAL         = 3.0f;
// Rate of boost change for the starting boost
static const CGFloat DB_STARTBOOST     = 0.0005f;
// How much speed is added from a ring
static const CGFloat DV_RINGBOOST      = 3.0f;

// Boost duration based on type
static const CGFloat TB_BOOSTER        = 1.5f;
static const CGFloat TB_INVINCIBILITY  = 3.0f;
static const CGFloat TB_RING           = 1.5f;

// Game frame rate
static const CGFloat SRSM_FPS = 60.0f;

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
        slowAnimating_ = NO;
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
        case kWorldStop:
            [self applyWorldStop:dt];
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
    
    if (vR_ > V_MIN) {
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
    // Below the V_MIN threshold, the engine shuts off and gravity takes effect
    else {
        vR_ -= (DV_MIN + dVMin_);
        dVMin_ += DDV_MIN;
        [[[GameManager gameManager] rocket] turnEngineFlameOff];        
    }
}

- (void) applyWorldStop:(ccTime)dt
{
    vR_ -= DV_WORLD_STOP;
    if (vR_ < 0) {
        vR_ = 0;
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
        restoreSpeed_ -= DV_COLLIDE;
        [[[GameManager gameManager] rocket] showWobbling];
        [[GameManager gameManager] invalidateSlowButton];          
    }
    // Colliding while speeding up from a slow
    else if (rocketMode_ == kSlowedRelease) {
        restoreSpeed_ -= DV_COLLIDE;
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
        // Slow only has an effect if it was used above it's minimum effective speed
        if (origSpeed_ > V_SLOW_MIN) {
            // Slow the rocket down
            vR_ -= dS_;
            dS_ += DDV_SLOWED_RATE_GROWTH;
            if (vR_ < V_SLOW_MIN) {
                vR_ = V_SLOW_MIN;
            }
            
            // Only decay the original speed if slow was pressed while going faster than the minimum V_MIN speed
            if (origSpeed_ > V_MIN) {
                // Slow the original speed down
                restoreSpeed_ -= DV_SLOW_DECAY;
                if (restoreSpeed_ < V_SLOW_DECAY_MIN) {
                    restoreSpeed_ = V_SLOW_DECAY_MIN;
                }
            }
        }
    }
    // In restore mode, rocket speed is being restored to the target speed
    else if (rocketMode_ == kSlowedRelease) {
        vR_ += dRestore_;
        if (vR_ >= restoreSpeed_) {
            vR_ = restoreSpeed_;
            rocketMode_ = kNormal;
        }        
    }
}

- (void) rocketSlowed
{
        // If slow is pressed when going below the minimum speed at which slow is effective
        if (vR_ < V_SLOW_MIN) {
            // Ensure that the slow animation is playing, but rocket is still in normal mode
            // In other words, slow has no effect, but the animation still needs to play
            if (!slowAnimating_) {
                slowAnimating_ = YES;
                [[[GameManager gameManager] rocket] showSlow];           
            }
        }
        // Slow pressed during a valid speed
        else {
            // Cut boost if rocket is slowed during one
            if (rocketMode_ == kBoosting && boostType_ != kStartBoost) {
                [delegate_ boostDisengaged:boostType_];    
                rocketMode_ = kSlowed;
                origSpeed_ = V_CRUISE;
                restoreSpeed_ = V_CRUISE;
                dRestore_ = DV_SLOWED_RESTORE;
                vR_ *= DV_SLOW_FACTOR;
                dS_ = 0.0f;
                slowAnimating_ = YES;
                [[[GameManager gameManager] rocket] showSlow];        
            }
            else if (rocketMode_ == kNormal) {
                rocketMode_ = kSlowed;        
                origSpeed_ = vR_;
                restoreSpeed_ = vR_;
                dRestore_ = DV_SLOWED_RESTORE;
                vR_ *= DV_SLOW_FACTOR;
                dS_ = 0.0f;
                slowAnimating_ = YES;                
                [[[GameManager gameManager] rocket] showSlow];
            }
        }
}

- (void) rocketSlowReleased
{
    if (rocketMode_ == kSlowed) {
        // Only restore speed if slow was pressed above its minimum effective speed
        // But either way, stop flapping
        if (origSpeed_ > V_SLOW_MIN) {
            rocketMode_ = kSlowedRelease;
        }
    }
    
    // Only if the animation is playing does it transition to flying
    if (slowAnimating_) {
        [[[GameManager gameManager] rocket] showFlying];        
        slowAnimating_ = NO;
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

- (void) worldStop
{
    rocketMode_ = kWorldStop;
}

- (BOOL) boostOn
{
    return rocketMode_ == kBoosting;
}

@end
