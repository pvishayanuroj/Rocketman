//
//  DialogueLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/7/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DialogueLayer.h"
#import "GameManager.h"

@implementation DialogueLayer

const CGFloat DL_COMBO_MOVE_AMT = 220.0f;
const CGFloat DL_COMBO_MOVEIN_DUR = 0.1f;
const CGFloat DL_COMBO_MOVEOUT_DUR = 0.1f;
const CGFloat DL_COMBO_HOLD_DUR = 0.7f;

- (id) init
{
    if ((self = [super init])) {
        
        [[GameManager gameManager] registerDialogueLayer:self];        
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) showCombo:(NSString *)filename
{
    sprite_ = [[CCSprite spriteWithFile:filename] retain];
    
    [self addChild:sprite_];
    sprite_.scaleY = 0.01f;
    sprite_.position = CGPointMake(-100.0f, 300.0f);
    
    CGPoint moveRight = CGPointMake(DL_COMBO_MOVE_AMT, 0);
    CGPoint moveLeft = CGPointMake(-DL_COMBO_MOVE_AMT, 0);    
    CCActionInterval *scaleUp = [CCScaleTo actionWithDuration:DL_COMBO_MOVEIN_DUR  scaleX:1.0 scaleY:1.0];
    CCActionInterval *right = [CCMoveBy actionWithDuration:DL_COMBO_MOVEIN_DUR  position:moveRight];
    CCActionInterval *easeRight = [CCEaseOut actionWithAction:right rate:2.0];    
    CCFiniteTimeAction *start = [CCSpawn actions:scaleUp, easeRight, nil];
    
    CCActionInterval *scaleDown = [CCScaleTo actionWithDuration:DL_COMBO_MOVEOUT_DUR scaleX:1.0f scaleY:0.01f];    
    CCActionInterval *left = [CCMoveBy actionWithDuration:DL_COMBO_MOVEOUT_DUR position:moveLeft];
    CCActionInterval *easeLeft = [CCEaseIn actionWithAction:left rate:2.0];    
    CCFiniteTimeAction *end = [CCSpawn actions:scaleDown, easeLeft, nil];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:DL_COMBO_HOLD_DUR];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(finishCombo)];
    CCAction *animation = [CCSequence actions:start, delay, end, done, nil];
    
    [[GameManager gameManager] dialoguePause];
    
    [sprite_ runAction:animation];
}

- (void) finishCombo
{
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    sprite_ = nil;
    
    [[GameManager gameManager] dialogueResume];    
}

@end
