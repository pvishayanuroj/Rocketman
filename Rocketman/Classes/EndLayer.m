//
//  EndLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "EndLayer.h"
#import "AnimatedButton.h"
#import "GameStateManager.h"

@implementation EndLayer

const CGFloat EL_BUTTON_SCALE = 0.8f;
const CGFloat EL_BUTTON_SCALE_BIG = 1.0f;
const CGFloat EL_RESTART_REL_Y = 0.35f;
const CGFloat EL_STAGE_REL_Y = 0.25f;
const CGFloat EL_RESTART_ROTATE_TIME = 2.0f;

- (id) init
{
    if ((self = [super init])) {
    
        restartIcon_ = [[CCSprite spriteWithFile:@"restart_icon.png"] retain];
        stageIcon_ = [[CCSprite spriteWithFile:@"stage_icon.png"] retain];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        restartIcon_.position = ccp(220, EL_RESTART_REL_Y * size.height);
        stageIcon_.position = ccp(265, EL_STAGE_REL_Y * size.height);
        
        AnimatedButton *restartButton = [AnimatedButton buttonWithImage:@"restart_text.png" target:self selector:@selector(restart)];
        AnimatedButton *stageButton = [AnimatedButton buttonWithImage:@"stage_text.png" target:self selector:@selector(stageSelect)];
        restartButton.position = ccp(0.5 * size.width, EL_RESTART_REL_Y * size.height);
        stageButton.position = ccp(0.5 * size.width, EL_STAGE_REL_Y * size.height);
        
        [self addChild:restartIcon_];
        [self addChild:stageIcon_];
        [self addChild:restartButton];
        [self addChild:stageButton];
        
        [self initActions];
    }
    return self;
}

- (void) dealloc
{
    [restartIcon_ release];
    [stageIcon_ release];
    
    [super dealloc];
}

- (void) initActions
{
    CCActionInterval *spinOnce = [CCRotateBy actionWithDuration:EL_RESTART_ROTATE_TIME angle:-360];
    CCAction *spin = [CCRepeatForever actionWithAction:spinOnce];
    [restartIcon_ runAction:spin];
    
    CGFloat duration = 0.05;
    CGFloat delay = 0.3;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:EL_BUTTON_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:EL_BUTTON_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:delay];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:delay];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]];
    [stageIcon_ runAction:pulse];    
}

- (void) restart
{
    [[GameStateManager gameStateManager] restartFromGameOver];
}

- (void) stageSelect
{
    [[GameStateManager gameStateManager] stageSelectFromGameOver];
}

@end
