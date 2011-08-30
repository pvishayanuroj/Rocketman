//
//  CircularMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"

@interface CircularMovement : Movement {
    
    CGFloat time_;
    
    CGFloat rate_;
    
    CGFloat radius_;
    
    CGPoint origin_;
    
    CGPoint previous_;
    
}

+ (id) circularMovement:(Obstacle *)obstacle rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (id) initCircularMovement:(Obstacle *)obstacle rate:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (CGPoint) getPoint;

@end
