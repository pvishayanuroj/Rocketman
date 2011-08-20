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
    
}

+ (id) staticMovement:(Obstacle *)obstacle;

- (id) initStaticMovement:(Obstacle *)obstacle;

/** Override the parent's move method */
- (void) move:(CGFloat)speed;

@end
