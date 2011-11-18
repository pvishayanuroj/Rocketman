//
//  CircularMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

@interface CircularMovement : Movement <NSCopying> {
    
    CGFloat time_;
    
    CGFloat rate_;
    
    CGFloat radius_;
    
    CGPoint origin_;
    
    CGPoint previous_;
    
}

@property (nonatomic, readonly) CGFloat time;
@property (nonatomic, readonly) CGFloat rate;
@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGPoint previous;

+ (id) circularMovement:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (id) initCircularMovement:(CGFloat)rate radius:(CGFloat)radius angle:(CGFloat)angle;

- (CGPoint) getPoint;

@end
