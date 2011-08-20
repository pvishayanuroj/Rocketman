//
//  SideMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"
#import "SideMovementDelegate.h"

@interface SideMovement : Movement {

    /** Current direction of movement */
    BOOL movingLeft_;
    
    /** Movement speed */
    CGFloat sideSpeed_;
    
    /** The left turnaround point */        
    CGFloat leftCutoff_;

    /** The right turnaround point */    
    CGFloat rightCutoff_;    
    
    /** Delegate object */
    id <SideMovementDelegate> delegate_;            
    
}

@property (nonatomic, assign) id <SideMovementDelegate> delegate;

+ (id) sideMovement:(Obstacle *)obstacle leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed;

- (id) initSideMovement:(Obstacle *)obstacle leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed;

- (void) changeSideSpeed:(CGFloat)sideSpeed;

@end
