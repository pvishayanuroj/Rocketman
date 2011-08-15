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

const CGFloat PL_BUTTON_SCALE = 0.8f;
const CGFloat PL_BUTTON_SCALE_BIG = 1.0f;
const CGFloat PL_RESTART_REL_Y = 0.6f;
const CGFloat PL_STAGE_REL_Y = 0.5f;
const CGFloat PL_RESTART_ROTATE_TIME = 2.0f;

- (id) init
{
	if ((self = [super init])) {
        
        [[GameManager gameManager] registerPauseLayer:self];
		self.isTouchEnabled = YES;        
     
        isPaused_ = NO;
        
        button_ = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"pause_button.png"] selectedSprite:[CCSprite spriteWithFile:@"pause_button.png"] target:self selector:@selector(select)];
        
        CCMenu *m = [CCMenu menuWithItems:button_, nil];
        m.position = CGPointMake(290, 450);
        [self addChild:m];
    }
    return self;
}

- (void) dealloc
{
    [restartIcon_ release];
    [stageIcon_ release];
    [restartButton_ release];
    [stageButton_ release];
    
    [super dealloc];
}

- (void) addButtons
{
    restartIcon_ = [[CCSprite spriteWithFile:@"restart_icon.png"] retain];
    stageIcon_ = [[CCSprite spriteWithFile:@"stage_icon.png"] retain];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    restartIcon_.position = ccp(220, PL_RESTART_REL_Y * size.height);
    stageIcon_.position = ccp(265, PL_STAGE_REL_Y * size.height);
    
    restartButton_ = [[AnimatedButton buttonWithImage:@"restart_text.png" target:self selector:@selector(restart)] retain];
    stageButton_ = [[AnimatedButton buttonWithImage:@"stage_text.png" target:self selector:@selector(stageSelect)] retain];
    restartButton_.position = ccp(0.5 * size.width, PL_RESTART_REL_Y * size.height);
    stageButton_.position = ccp(0.5 * size.width, PL_STAGE_REL_Y * size.height);
    
    [self addChild:restartIcon_];
    [self addChild:stageIcon_];
    [self addChild:restartButton_];
    [self addChild:stageButton_];  
    
    [self initActions];
}

- (void) initActions
{
    CCActionInterval *spinOnce = [CCRotateBy actionWithDuration:PL_RESTART_ROTATE_TIME angle:-360];
    CCAction *spin = [CCRepeatForever actionWithAction:spinOnce];
    [restartIcon_ runAction:spin];
    
    CGFloat duration = 0.05;
    CGFloat delay = 0.3;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:PL_BUTTON_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:PL_BUTTON_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:delay];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:delay];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]];
    [stageIcon_ runAction:pulse];    
}

- (void) removeButtons
{
    [restartIcon_ removeFromParentAndCleanup:YES];
    [stageIcon_ removeFromParentAndCleanup:YES];
    [restartButton_ removeFromParentAndCleanup:YES];
    [stageButton_ removeFromParentAndCleanup:YES];
}

- (void) select
{
    // Pause the game
    if (!isPaused_) {
        isPaused_ = YES;
        [[GameManager gameManager] pause];
        [[AudioManager audioManager] pauseSound];
        [button_ setNormalImage:[CCSprite spriteWithFile:@"resume_button.png"]];
        [button_ setSelectedImage:[CCSprite spriteWithFile:@"resume_button.png"]];      
        [self addButtons];
    }
    // Unpause the game
    else {
        isPaused_ = NO;        
        [self removeButtons];
        [button_ setNormalImage:[CCSprite spriteWithFile:@"pause_button.png"]];
        [button_ setSelectedImage:[CCSprite spriteWithFile:@"pause_button.png"]];        
        [[AudioManager audioManager] resumeSound];        
        [[GameManager gameManager] resume];                      
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

@end
