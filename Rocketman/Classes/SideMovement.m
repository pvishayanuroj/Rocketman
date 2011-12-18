//
//  SideMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SideMovement.h"
#import "GameObject.h"
#import "GameManager.h"
#import "Rocket.h"
#import "UtilFuncs.h"

@implementation SideMovement

@synthesize leftCutoff = leftCutoff_;
@synthesize rightCutoff = rightCutoff_;
@synthesize speed = speed_;
@synthesize movingLeft = movingLeft_;
@synthesize delegate = delegate_;

/*
+ (id) sideMovement:(GameObject *)object distance:(CGFloat)distance speed:(CGFloat)speed
{
    CGFloat leftCutoff = object.position.x - distance * 0.5f;
    CGFloat rightCutoff = leftCutoff + distance;
    return [[[self alloc] initSideMovement:leftCutoff rightCutoff:rightCutoff speed:speed] autorelease];
}
*/

+ (id) sideMovement:(GameObject *)object leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed
{
    return [[[self alloc] initSideMovement:object.position.x leftCutoff:leftCutoff rightCutoff:rightCutoff speed:speed] autorelease];
}

- (id) initSideMovement:(CGFloat)xPos leftCutoff:(CGFloat)leftCutoff rightCutoff:(CGFloat)rightCutoff speed:(CGFloat)speed
{
    if ((self = [super initMovement])) {
        
        sideSpeed_ = speed;
        leftCutoff_ = leftCutoff;
        rightCutoff_ = rightCutoff;
        delegate_ = nil;
        
        // Based on the object's starting position, we want to move towards the opposite end
        // Object is beyond the left cutoff, move right
        if (xPos < leftCutoff) {
            movingLeft_ = NO;
        }
        // Object is beyond the right cutoff, move left
        else if (xPos > rightCutoff) {
            movingLeft_ = YES;
        }
        // Otherwise object is in between the boundaries, move in any direction
        else {
            movingLeft_ = [UtilFuncs randomChoice];
        }
        
        proximityTriggerOn_ = NO;
        proximityTriggered_ = NO;
        randomTriggerOn_ = NO;
        randomTriggers_ = nil;
        
        rocket_ = nil;
    }
    return self;
}

- (void) dealloc
{    
    [rocket_ release];
    [randomTriggers_ release];
    delegate_ = nil;
    
    [super dealloc];
}

- (id) copyWithZone: (NSZone *)zone
{
    SideMovement *cpy = [[SideMovement allocWithZone:zone] initSideMovement:objectXPos_ leftCutoff:self.leftCutoff rightCutoff:self.rightCutoff speed:self.speed];
    cpy.movingLeft = self.movingLeft;
    return cpy;
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    CGFloat dx;
    
    // Moving left
    if (movingLeft_) {
        // Check if we got to the turnaround point to move right again
        if (object.position.x < leftCutoff_) {
            // Reset flags
            movingLeft_ = NO;
            proximityTriggered_ = NO;
            
            // Come up with a new set of random triggers if enabled
            if (randomTriggerOn_) {
                [self populateRandomTriggers:movingLeft_];
            }
            
            // Alert the delegate (if any)
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementLeftTurnaround:)]) {
                [delegate_ sideMovementLeftTurnaround:self];
            }
            
            dx = sideSpeed_;
        }
        else {
            dx = -sideSpeed_;
        }
    }
    // Moving right
    else {
        // Check if we got to the turnaround point to move left
        if (object.position.x > rightCutoff_) {
            movingLeft_ = YES;
            proximityTriggered_ = NO;            
            
            // Come up with a new set of random triggers if enabled
            if (randomTriggerOn_) {
                [self populateRandomTriggers:movingLeft_];
            }            
            
            // Alert the delegate (if any)
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementRightTurnaround:)]) {
                [delegate_ sideMovementRightTurnaround:self];
            }            
            
            dx = -sideSpeed_;            
        }
        else {
            dx = sideSpeed_;
        }
    }    
    
    CGPoint p = CGPointMake(dx, 0);     
    object.position = ccpAdd(object.position, p);    
    objectXPos_ = object.position.x;
    
    // Check for proximity triggering
    if (proximityTriggerOn_ && !proximityTriggered_) {
        CGFloat distance = rocket_.position.x - object.position.x;
        if (fabs(distance) < proximityDistance_) {
            proximityTriggered_ = YES;
            // Alert the delegate (if any) of the proximity trigger firing
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementProximityTrigger:)]) {
                [delegate_ sideMovementProximityTrigger:self];
            }
        }
    }
    
    // Check for random triggering
    if (randomTriggerOn_ && [randomTriggers_ count] > 0) {
        NSNumber *trigger = [randomTriggers_ lastObject];
        CGFloat val = [trigger floatValue];
        // Moving left, check if past the next trigger
        if (movingLeft_ && object.position.x < val) {
            // Alert the delegate (if any) of the random trigger firing            
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementRandomTrigger:)]) {
                [delegate_ sideMovementRandomTrigger:self];
                [randomTriggers_ removeLastObject];
            }
        }
        // Moving right, check if past the next trigger
        else if (!movingLeft_ && object.position.x > val) {
            // Alert the delegate (if any) of the random trigger firing                 
            if (delegate_ && [delegate_ respondsToSelector:@selector(sideMovementRandomTrigger:)]) {
                [delegate_ sideMovementRandomTrigger:self];
                [randomTriggers_ removeLastObject];
            }            
        }
    }
}

- (void) setProximityTrigger:(CGFloat)distance
{
    proximityTriggerOn_ = YES;
    proximityDistance_ = distance;
    
    // Hold a reference to the rocket
    [rocket_ release];
    rocket_ = [[[GameManager gameManager] rocket] retain];    
}

- (void) setRandomTrigger:(NSUInteger)numPerTurn
{
    randomTriggers_ = [[NSMutableArray arrayWithCapacity:numPerTurn] retain];
    numRandomTriggers_ = numPerTurn;
    randomTriggerOn_ = YES;
}

- (void) changeSideSpeed:(CGFloat)sideSpeed
{
    sideSpeed_ = sideSpeed;
}

- (void) populateRandomTriggers:(BOOL)movingLeft
{
    [randomTriggers_ removeAllObjects];
    
    for (int i = 0; i < numRandomTriggers_; i++) {
        CGFloat val = (CGFloat)[UtilFuncs randomIncl:leftCutoff_ b:rightCutoff_];
        [randomTriggers_ addObject:[NSNumber numberWithFloat:val]];
    }
    
    // If moving left, sort in ascending order, so that rightmost triggers are activated first
    if (movingLeft) {
        [randomTriggers_ sortUsingSelector:@selector(compare:)];
    }
    // If moving right, sort in descending order, so that leftmost triggers are activated first
    else {
        [randomTriggers_ sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CGFloat v1 = [obj1 floatValue];
            CGFloat v2 = [obj2 floatValue];            
            if (v1 > v2) {
                return NSOrderedAscending;
            }
            if (v1 < v2) {
                return NSOrderedDescending;
            }
            return NSOrderedSame;
        }];
    }
}

@end
