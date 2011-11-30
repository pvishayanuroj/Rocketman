//
//  RelativeMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

/**
 * Movement derived class representing an inert object that will "fall" based on the speed of rocket movement
 */
@interface RelativeMovement : Movement <NSCopying> {
    
    CGFloat equalRate_;
    
    CGFloat fallRate_;
    
    CGFloat relativeFactor_;
}

@property (nonatomic, readonly) CGFloat equalRate;
@property (nonatomic, readonly) CGFloat fallRate;

/** Object falls however much the rocket moves */
+ (id) relativeMovement:(CGFloat)fallRate equalRate:(CGFloat)equalRate;

/** Method to initialize a static movement */
- (id) initRelativeMovement:(CGFloat)fallRate equalRate:(CGFloat)equalRate;

@end
