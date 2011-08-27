//
//  ConstantMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"

@interface ConstantMovement : Movement {
    
    CGPoint rate_;
    
}

+ (id) constantMovement:(Obstacle *)obstacle rate:(CGPoint)rate;

+ (id) constantMovementDown:(Obstacle *)obstacle rate:(CGFloat)rate;

- (id) initConstantMovement:(Obstacle *)obstacle rate:(CGPoint)rate;

@end
