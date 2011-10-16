//
//  Focus.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Focus.h"
#import "Obstacle.h"

@implementation Focus

const CGFloat FS_CIRCLE_SCALE = 0.6f;
const CGFloat FS_CIRCLE_SCALE_LARGE = 0.8f;
const CGFloat FS_CIRCLE_ROTATE_TIME = 2.0f;
const CGFloat FS_CIRCLE_PULSE_SPEED = 0.05f;
const CGFloat FS_CIRCLE_PULSE_DELAY = 0.3f;
const CGFloat FS_ARROW_MOVE_AMT = 40.0f;
const CGFloat FS_ARROW_MOVE_SPEED = 0.3f;
//const CGFloat FS_ARROW_MOVE_SPEED = 0.05f;

#pragma mark - Object Lifecycle

+ (id) focusWithObstacle:(Obstacle *)obstacle delay:(CGFloat)delay
{
    return [[[self alloc] initFocus:obstacle fixed:nil delay:delay] autorelease];
}

+ (id) focusWithFixed:(NSString *)fixed delay:(CGFloat)delay
{
    return [[[self alloc] initFocus:nil fixed:fixed delay:delay] autorelease];
}

- (id) initFocus:(Obstacle *)obstacle fixed:(NSString *)fixed delay:(CGFloat)delay
{
    if ((self = [super init])) {
     
        // If focusing on an obstacle
        if (obstacle) {
            sprite_ = [[CCSprite spriteWithFile:@"Focus Circle.png"] retain];
            sprite_.position = obstacle.position;
            sprite_.scale = FS_CIRCLE_SCALE;
            sprite_.visible = NO;
            [self circleAnimation:delay];
        }
        // Focusing on a UI element
        else {
            sprite_ = [[CCSprite spriteWithFile:@"Focus Arrow.png"] retain];
            sprite_.position = [self getArrowPosition:fixed];
            sprite_.visible = NO;
            [self arrowAnimation:delay];
        }
        
        [self addChild:sprite_];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

#pragma mark - Animations

- (void) circleAnimation:(CGFloat)delay
{
    CCDelayTime *wait = [CCDelayTime actionWithDuration:delay];    
    CCCallFunc *show = [CCCallFunc actionWithTarget:self selector:@selector(unhide)];
    [self runAction:[CCSequence actions:wait, show, nil]];
    
    CCActionInterval *grow = [CCScaleTo actionWithDuration:FS_CIRCLE_PULSE_SPEED scale:FS_CIRCLE_SCALE_LARGE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:FS_CIRCLE_PULSE_SPEED scale:FS_CIRCLE_SCALE];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:FS_CIRCLE_PULSE_DELAY];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:FS_CIRCLE_PULSE_DELAY];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]];   

    [sprite_ runAction:pulse];
}
     
- (void) unhide
{
    sprite_.visible = YES;
}

- (CGPoint) getArrowPosition:(NSString *)element
{
    
}

- (void) arrowAnimation:(CGFloat)delay
{

}

@end
