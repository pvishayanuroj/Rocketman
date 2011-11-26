//
//  FallingRocket.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "FallingRocket.h"
#import "ArcMovement.h"
#import "ConstantMovement.h"

@implementation FallingRocket

// Startin position of the rocket
const CGFloat FL_START_X = 160.0f;
const CGFloat FL_START_Y = 450.0f;
// Rocket fall speed
const CGFloat FL_FALL_SPEED = 0.6f;
// How far the rocket rotates per arc
const CGFloat FL_ROTATION = 15.0f;
// How long an arc lasts
const CGFloat FL_ARC_DURATION = 2.0f;
// How far down and over the arc goes
const CGFloat FL_ARC_XOFFSET = 90.0f;
const CGFloat FL_ARC_YOFFSET = 15.0f;

+ (id) fallingRocket
{
    return [[[self alloc] initFallingRocket] autorelease];
}

- (id) initFallingRocket
{
    if ((self = [super initGameObject])) {
        
        self.position = CGPointMake(FL_START_X, FL_START_Y);
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket2 Parachute 01.png"] retain];
        sprite_.rotation = -FL_ROTATION;
        [self addChild:sprite_];
        
        // Setup movements
        [movements_ addObject:[RepeatedArcMovement repeatedArcMovement:self.position]];
        
        fallingRight_ = YES;
        [self startArc:fallingRight_];
        
        [self schedule:@selector(fall:) interval:1/60.0f];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) fall:(ccTime)dt
{
    CGPoint fall = CGPointMake(0, -FL_FALL_SPEED);
    self.position = ccpAdd(self.position, fall);
}

- (void) startArc:(BOOL)right
{
    [sprite_ stopAllActions];
    
    // Setup arc movement
    ccBezierConfig bezier;
    if (right) {
        bezier.controlPoint_1 = CGPointMake(FL_ARC_XOFFSET * 0.33f, -FL_ARC_YOFFSET);
        bezier.controlPoint_2 = CGPointMake(FL_ARC_XOFFSET * 0.66f, -FL_ARC_YOFFSET);    
        bezier.endPosition = CGPointMake(FL_ARC_XOFFSET, 0);
    }
    else {
        bezier.controlPoint_1 = CGPointMake(-FL_ARC_XOFFSET * 0.33f, -FL_ARC_YOFFSET);
        bezier.controlPoint_2 = CGPointMake(-FL_ARC_XOFFSET * 0.66f, -FL_ARC_YOFFSET);    
        bezier.endPosition = CGPointMake(-FL_ARC_XOFFSET, 0);        
    }
    
    CCActionInterval *arc = [CCBezierBy actionWithDuration:FL_ARC_DURATION bezier:bezier];
    CCActionInterval *easeArc = [CCEaseInOut actionWithAction:arc rate:2.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(arcDone)];
    CCFiniteTimeAction *a1 = [CCSequence actions:easeArc, done, nil];
    
    // Setup rotation
    CCActionInterval *rotate;
    CGFloat angle = right ? -FL_ROTATION : FL_ROTATION;
    rotate = [CCRotateTo actionWithDuration:FL_ARC_DURATION angle:angle];    
    CCActionInterval *easeRotate = [CCEaseInOut actionWithAction:rotate rate:2.0f];
    
    [sprite_ runAction:[CCSpawn actions:a1, easeRotate, nil]];
}

- (void) arcDone
{
    fallingRight_ = !fallingRight_;
    [self startArc:fallingRight_];
}

@end
