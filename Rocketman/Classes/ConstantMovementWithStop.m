//
//  ConstantMovementWithStop.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ConstantMovementWithStop.h"
#import "Obstacle.h"
#import "GameObject.h"

@implementation ConstantMovementWithStop

@synthesize rate = rate_;
@synthesize targetHeight = targetHeight_;
@synthesize moving = moving_;
@synthesize fallingDown = fallingDown_;

+ (id) constantMovementWithStop:(CGFloat)rate withStop:(CGFloat)height 
{
    return [[[self alloc] initConstantMovementWithStop:rate height:height] autorelease];    
}

- (id) initConstantMovementWithStop:(CGFloat)rate height:(CGFloat)height
{
    if ((self = [super initMovement])) {
        
        rate_ = rate;
        moving_ = YES;
        targetHeight_ = height;
        fallingDown_ = rate < 0;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    ConstantMovementWithStop *cpy = [[ConstantMovementWithStop allocWithZone:zone] initConstantMovementWithStop:self.rate height:self.targetHeight];
    cpy.moving = self.moving;
    cpy.fallingDown = self.fallingDown;
    return cpy;
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    if (moving_) {
        CGPoint p = CGPointMake(0, rate_);      
        // Going downwards
        if (fallingDown_) {
            // Check if target has been reached
            if (object.position.y < targetHeight_) {
                moving_ = NO;
                p.y = 0;
            }
        }
        // Going upwards
        else {
            // Check if target has been reached
            if (object.position.y > targetHeight_) {
                moving_ = NO;
                p.y = 0;
            }         
        }
        // Actual movement
        object.position = ccpAdd(object.position, p);                            
    }
}

@end
