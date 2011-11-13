//
//  PauseLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PauseLayer.h"
#import "GameManager.h"
#import "AudioManager.h"
#import "AnimatedButton.h"
#import "GameStateManager.h"

@implementation PauseLayer

const CGFloat PL_PAUSE_X = 290.0f;
const CGFloat PL_PAUSE_Y = 450.0f;
const CGFloat PL_STAGE_SCALE = 0.8f;
const CGFloat PL_STAGE_SCALE_BIG = 1.0f;
const CGFloat PL_RESTART_REL_Y = 0.6f;
const CGFloat PL_STAGE_REL_Y = 0.5f;
const CGFloat PL_RESUME_REL_Y = 0.4f;
const CGFloat PL_RESTART_X = 220.0f;
const CGFloat PL_STAGE_X = 260.0f;
const CGFloat PL_RESUME_X = 225.0f;
const CGFloat PL_RESTART_ROTATE_TIME = 2.0f;
const CGFloat PL_RESUME_BLINK_DELAY = 0.5f;
const CGFloat PL_STAGE_PULSE_DELAY = 0.3f;
const CGFloat PL_STAGE_RESIZE_DURATION = 0.05f;

- (id) init
{
	if ((self = [super init])) {
        
        [[GameManager gameManager] registerPauseLayer:self];     
     
        isPaused_ = NO;
        
        button_ = [[AnimatedButton buttonWithImage:@"pause_button.png" target:self selector:@selector(pauseGame)] retain];
        button_.position = CGPointMake(PL_PAUSE_X, PL_PAUSE_Y);
        [self addChild:button_];
    }
    return self;
}

- (void) dealloc
{
    [button_ release];
    [restartIcon_ release];
    [stageIcon_ release];
    [resumeIcon_ release];
    [restartButton_ release];
    [stageButton_ release];
    [resumeButton_ release];    
    
    [super dealloc];
}

- (void) addButtons
{
    restartIcon_ = [[CCSprite spriteWithFile:@"restart_icon.png"] retain];
    stageIcon_ = [[CCSprite spriteWithFile:@"stage_icon.png"] retain];
    resumeIcon_ = [[CCSprite spriteWithFile:@"resume_button.png"] retain];    
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    restartIcon_.position = CGPointMake(PL_RESTART_X, PL_RESTART_REL_Y * size.height);
    stageIcon_.position = CGPointMake(PL_STAGE_X, PL_STAGE_REL_Y * size.height);
    resumeIcon_.position = CGPointMake(PL_RESUME_X, PL_RESUME_REL_Y * size.height);
    
    restartButton_ = [[AnimatedButton buttonWithImage:@"restart_text.png" target:self selector:@selector(restart)] retain];
    stageButton_ = [[AnimatedButton buttonWithImage:@"stage_text.png" target:self selector:@selector(stageSelect)] retain];
    resumeButton_ = [[AnimatedButton buttonWithImage:@"resume_text.png" target:self selector:@selector(resumeGame)] retain];    
    restartButton_.position = CGPointMake(0.5f * size.width, PL_RESTART_REL_Y * size.height);
    stageButton_.position = CGPointMake(0.5f * size.width, PL_STAGE_REL_Y * size.height);
    resumeButton_.position = CGPointMake(0.5f * size.width, PL_RESUME_REL_Y * size.height);    
    
    [self addChild:restartIcon_];
    [self addChild:stageIcon_];
    [self addChild:resumeIcon_];
    [self addChild:restartButton_];
    [self addChild:stageButton_];  
    [self addChild:resumeButton_];
    
    [self initActions];
}

- (void) initActions
{
    CCActionInterval *spinOnce = [CCRotateBy actionWithDuration:PL_RESTART_ROTATE_TIME angle:-360];
    CCAction *spin = [CCRepeatForever actionWithAction:spinOnce];
    [restartIcon_ runAction:spin];
    
    CGFloat duration = PL_STAGE_RESIZE_DURATION;
    CGFloat pulseDelay = PL_STAGE_PULSE_DELAY;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:PL_STAGE_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0f];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:PL_STAGE_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0f];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:pulseDelay];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:pulseDelay];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]];
    [stageIcon_ runAction:pulse];  
    
    CGFloat blinkDelay = PL_RESUME_BLINK_DELAY;    
    CCActionInterval *hide = [CCFadeOut actionWithDuration:0.0f];
    CCActionInterval *hideDelay = [CCDelayTime actionWithDuration:blinkDelay];    
    CCActionInterval *show = [CCFadeIn actionWithDuration:0.0f];    
    CCActionInterval *showDelay = [CCDelayTime actionWithDuration:blinkDelay];    
    CCAction *blink = [CCRepeatForever actionWithAction:[CCSequence actions:hide, hideDelay, show, showDelay, nil]];
    [resumeIcon_ runAction:blink];      
}

- (void) removeButtons
{
    [restartIcon_ removeFromParentAndCleanup:YES];
    [stageIcon_ removeFromParentAndCleanup:YES];
    [resumeIcon_ removeFromParentAndCleanup:YES];
    [restartButton_ removeFromParentAndCleanup:YES];
    [stageButton_ removeFromParentAndCleanup:YES];
    [resumeButton_ removeFromParentAndCleanup:YES];
    
    [button_ release];
    [restartIcon_ release];
    [stageIcon_ release];
    [resumeIcon_ release];
    [restartButton_ release];
    [stageButton_ release];
    [resumeButton_ release];
    
    button_ = nil;
    restartIcon_ = nil;
    stageIcon_ = nil;
    resumeIcon_ = nil;
    restartButton_ = nil;
    stageIcon_ = nil;
    resumeButton_ = nil;
}

- (void) pauseGame
{
    // Pause the game
    if (!isPaused_) {
        isPaused_ = YES;
        button_.visible = NO;
        [[GameManager gameManager] pause];
        [[AudioManager audioManager] pauseSound];
        [self addButtons];
    }
}

- (void) restart
{
    [[GameStateManager gameStateManager] restartFromPause];
}

- (void) stageSelect
{
    [[GameStateManager gameStateManager] stageSelectFromPause];
}

- (void) resumeGame
{
    isPaused_ = NO;        
    button_.visible = YES;    
    [self removeButtons];       
    [[AudioManager audioManager] resumeSound];        
    [[GameManager gameManager] resume];               
}

@end
