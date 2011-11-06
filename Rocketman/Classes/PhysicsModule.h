//
//  PhysicsModule.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "PhysicsModuleDelegate.h"

typedef enum {
    kTimedBoost,
    kTargetBoost
} BoostMode;

typedef enum {
    kStopped,
    kNormal,
    kCollided,
    kSlowed,
    kBoosting
} RocketMode;

@interface PhysicsModule : CCNode {
    
    /** Rocket speed */
    CGFloat vR_;
    
    CGFloat dVMin_;
    
    /** Boost amount per tick */
    CGFloat vB_;
    
    /** Boost amount change per tick */
    CGFloat dB_;
    
    /** Rocket state */
    RocketMode rocketMode_;
    
    /** Current boost type (stored for the GameLayer) */
    BoostType boostType_;
    
    /** Current boost mode */
    BoostMode boostMode_;
    
    /** Target speed at which to stop boost */
    CGFloat boostTarget_;
    
    /** Counts down until the end of boost */
    CGFloat boostTimer_;
    
    /** Original speed before slow/collision */
    CGFloat origSpeed_;
    
    /** Rate at which speed increases back to original speed after slow/collide */
    CGFloat dRestore_;
    
    /** Counts down until the end of the slow period */
    CGFloat slowTimer_;
    
    /** Delegate object */
    id <PhysicsModuleDelegate> delegate_;
}

@property (nonatomic, readonly) CGFloat rocketSpeed;
@property (nonatomic, readonly) BOOL boostOn;
@property (nonatomic, readonly) BOOL isSlowed;
@property (nonatomic, readonly) RocketMode rocketMode;
@property (nonatomic, readonly) BoostType boostType;
@property (nonatomic, assign) id <PhysicsModuleDelegate> delegate;

+ (id) physicsModule;

- (id) initPhysicsModule;

- (void) step:(ccTime)dt;

- (void) calculateSpeed:(ccTime)dt;

- (void) applyBoost:(ccTime)dt;

- (void) applySlow:(ccTime)dt;

- (void) rocketCollision;

- (void) rocketSlowed;

- (void) engageBoost:(BoostType)boostType;

@end
