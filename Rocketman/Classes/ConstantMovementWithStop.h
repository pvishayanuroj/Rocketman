//
//  ConstantMovementWithStop.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

@interface ConstantMovementWithStop : Movement {
    
    /** Rate at which object falls relative to rocket speed */
    CGFloat rate_;
    
    /** The height at which to stop moving */
    CGFloat targetHeight_;
    
    /** Whether or not we are moving */
    BOOL moving_;
    
    /** Direction of movement */
    BOOL fallingDown_;        
    
}

/** Moves the object down at the given rate every tick until the specified height is reached */
+ (id) constantMovementWithStop:(CGFloat)rate withStop:(CGFloat)height;

/** Method to initialize a constant movement with stop */
- (id) initConstantMovementWithStop:(CGFloat)rate height:(CGFloat)height;

@end
