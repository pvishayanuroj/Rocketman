//
//  StaticMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

/**
 * Movement derived class representing an inert object that will "fall" based on the speed of rocket movement
 */
@interface StaticMovement : Movement <NSCopying> {
    
    /** Rate at which object falls relative to rocket speed */
    CGFloat rate_;

}

@property (nonatomic, readonly) CGFloat rate;

/** Object falls however much the rocket moves */
+ (id) staticMovement;

/** Object falls however much the rocket moves multiplied by the given factor */
+ (id) staticMovement:(CGFloat)rate;

/** Method to initialize a static movement */
- (id) initStaticMovement:(CGFloat)rate;

@end
