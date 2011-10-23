//
//  CircularMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

@interface CircularMovement : Movement {
    
    CGFloat time_;
    
    CGFloat rate_;
    
    CGFloat radius_;
    
    CGPoint origin_;
    
    CGPoint previous_;
    
}

+ (id) circularMovement:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (id) initCircularMovement:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (CGPoint) getPoint;

@end
