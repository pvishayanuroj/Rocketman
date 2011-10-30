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
const CGFloat FS_ARROW_SCALE = 0.8f;
const CGFloat FS_ARROW_YOFFSET = 70.0f;
const CGFloat FS_ARROW_MOVE_AMT = 40.0f;
const CGFloat FS_ARROW_MOVEDOWN_SPEED = 0.25f;
const CGFloat FS_ARROW_MOVEUP_SPEED = 0.35f;

#pragma mark - Object Lifecycle

+ (id) focusWithObstacle:(Obstacle *)obstacle delay:(CGFloat)delay
{
    return [[[self alloc] initFocus:obstacle buttonType:0 delay:delay] autorelease];
}

+ (id) focusWithFixed:(ButtonType)buttonType delay:(CGFloat)delay
{
    return [[[self alloc] initFocus:nil buttonType:buttonType delay:delay] autorelease];
}

- (id) initFocus:(Obstacle *)obstacle buttonType:(ButtonType)buttonType delay:(CGFloat)delay
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
            sprite_.position = [self getArrowPosition:buttonType];
            sprite_.scale = FS_ARROW_SCALE;            
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

- (CGPoint) getArrowPosition:(ButtonType)buttonType
{
    CGPoint point;
    
    switch (buttonType) {
        case kBoostButton:
            point = CGPointMake(HUD_BOOST_BUTTON_X, HUD_BOOST_BUTTON_Y);        
            break;
        case kCatButton:
            point = CGPointMake(HUD_CAT_BUTTON_X, HUD_CAT_BUTTON_Y);        
            break;
        case kBombButton:
            point = CGPointMake(HUD_BOMB_BUTTON_X, HUD_BOMB_BUTTON_Y);
            break;
        case kSlowButton:
            point = CGPointMake(HUD_SLOW_BUTTON_X, HUD_SLOW_BUTTON_Y);
            break;
        default:
            break;
    }
    
    point.y += FS_ARROW_YOFFSET;
    return point;
}

- (void) arrowAnimation:(CGFloat)delay
{
    CCDelayTime *wait = [CCDelayTime actionWithDuration:delay];    
    CCCallFunc *show = [CCCallFunc actionWithTarget:self selector:@selector(unhide)];
    [self runAction:[CCSequence actions:wait, show, nil]];    
    
    CCActionInterval *up = [CCMoveBy actionWithDuration:FS_ARROW_MOVEUP_SPEED position:CGPointMake(0, FS_ARROW_MOVE_AMT)];
    CCActionInterval *down = [CCMoveBy actionWithDuration:FS_ARROW_MOVEDOWN_SPEED position:CGPointMake(0, -FS_ARROW_MOVE_AMT)];    
    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:0.10f];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:0.03f];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:up, delay1, down, delay2, nil]];   
    
    [sprite_ runAction:pulse];    
}

@end
