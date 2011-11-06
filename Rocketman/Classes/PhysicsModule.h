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

@interface PhysicsModule : CCNode {
    
    /** Rocket speed */
    CGFloat vR_;
    
    /** Boost amount per tick */
    CGFloat vB_;
    
    /** Boost amount change per tick */
    CGFloat dB_;
    
    /** Whether or not the rocket is stopped */ 
    BOOL rocketStopped_;
    
    /** Whether or not boost is on */
    BOOL boostOn_;
    
    /** Current boost type (stored for the GameLayer) */
    BoostType boostType_;
    
    /** Current boost mode */
    BoostMode boostMode_;
    
    /** Target speed at which to stop boost */
    CGFloat boostTarget_;
    
    /** Counts down until the end of boost */
    CGFloat boostTimer_;
    
    /** Delegate object */
    id <PhysicsModuleDelegate> delegate_;
}

@property (nonatomic, readonly) CGFloat rocketSpeed;
@property (nonatomic, readonly) BOOL boostOn;
@property (nonatomic, readonly) BoostType boostType;
@property (nonatomic, assign) id <PhysicsModuleDelegate> delegate;

+ (id) physicsModule;

- (id) initPhysicsModule;

- (void) step:(ccTime)dt;

- (void) calculateSpeed:(ccTime)dt;

- (void) applyBoost:(ccTime)dt;

- (void) engageBoost:(BoostType)boostType;

@end
