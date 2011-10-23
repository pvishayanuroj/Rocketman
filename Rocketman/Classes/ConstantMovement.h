//
//  ConstantMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

/** Class to allow an object to move by a constant amount every tick */
@interface ConstantMovement : Movement {
    
    /** Amount that the object will move each tick */
    CGPoint rate_;
    
}

/** Every tick will move the object by the given rate */
+ (id) constantMovement:(CGPoint)rate;

/** Every tick will move the object down by the given rate */
+ (id) constantMovementDown:(CGFloat)rate;

/** Method to initialize a constant movement */
- (id) initConstantMovement:(CGPoint)rate;

@end
