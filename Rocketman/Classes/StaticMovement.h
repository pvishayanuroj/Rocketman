//
//  StaticMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"

/**
 * Movement derived class representing an inert object that will "fall" based on the speed of rocket movement
 */
@interface StaticMovement : Movement {
    
    /** Rate at which object falls relative to rocket speed */
    CGFloat rate_;

}

+ (id) staticMovement:(Obstacle *)obstacle;

+ (id) staticMovement:(Obstacle *)obstacle rate:(CGFloat)rate;

- (id) initStaticMovement:(Obstacle *)obstacle rate:(CGFloat)rate;

/** Override the parent's move method */
- (void) move:(CGFloat)speed;

@end
