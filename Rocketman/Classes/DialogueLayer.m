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

const CGFloat DL_MOVE_AMT = 200.0f;

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

- (void) showCombo:(NSUInteger)comboNum
{
    NSString *filename = [NSString stringWithFormat:@"dialogue_combo%d.png", comboNum];
    sprite_ = [[CCSprite spriteWithFile:filename] retain];
    
    [self addChild:sprite_];
    sprite_.scaleY = 0.01f;
    sprite_.position = CGPointMake(-100.0f, 300.0f);
    
    CGPoint moveRight = CGPointMake(DL_MOVE_AMT, 0);
    CGPoint moveLeft = CGPointMake(-DL_MOVE_AMT, 0);    
    CCActionInterval *scaleUp = [CCScaleTo actionWithDuration:0.1f scaleX:1.0 scaleY:1.0];
    CCActionInterval *right = [CCMoveBy actionWithDuration:0.1f position:moveRight];
    CCActionInterval *easeRight = [CCEaseOut actionWithAction:right rate:2.0];    
    CCFiniteTimeAction *start = [CCSpawn actions:scaleUp, easeRight, nil];
    
    CCActionInterval *scaleDown = [CCScaleTo actionWithDuration:0.1f scaleX:1.0f scaleY:0.01f];    
    CCActionInterval *left = [CCMoveBy actionWithDuration:0.1f position:moveLeft];
    CCActionInterval *easeLeft = [CCEaseIn actionWithAction:left rate:2.0];    
    CCFiniteTimeAction *end = [CCSpawn actions:scaleDown, easeLeft, nil];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.7f];
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
