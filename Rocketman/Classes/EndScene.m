//
//  EndScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "EndScene.h"
#import "EngineParticleSystem.h"
#import "IncrementingText.h"
#import "AnimatedButton.h"
#import "GameStateManager.h"

@implementation EndScene

static const CGFloat ES_SCORE_TIME = 2.0f;
static const CGFloat ES_BUTTON_SCALE = 0.8f;
static const CGFloat ES_BUTTON_SCALE_BIG = 1.0f;
static const CGFloat ES_RESTART_REL_Y = 0.35f;
static const CGFloat ES_STAGE_REL_Y = 0.25f;
static const CGFloat ES_RESTART_ROTATE_TIME = 2.0f;

+ (id) endSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score
{
    return [[[self alloc] initEndSceneWithLevel:levelNum score:score] autorelease];
}

- (id) initEndSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score
{
    if ((self = [super init])) {
    
        // Add background sky
        NSString *backgroundName = [NSString stringWithFormat:@"Sky Background.png"];
        CCSprite *bg = [CCSprite spriteWithFile:backgroundName];
        [self addChild:bg z:0];
        bg.anchorPoint = CGPointZero;        
        
        // Add foreground element
        NSString *foregroundName = [NSString stringWithFormat:@"Mountains Parallax.png"];
        CCSprite *fg = [CCSprite spriteWithFile:foregroundName];
        fg.anchorPoint = CGPointZero;
        [self addChild:fg z:1];

        // Wrecked ship & smoke
        CCParticleSystem *smoke = [EngineParticleSystem PSForBrokenRocket];
        smoke.position = CGPointMake(200, 15);
        [self addChild:smoke z:2];        
        
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket2 Stuck"];
        CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
        CCAction *wreckedAnimation = [CCRepeatForever actionWithAction:animate];	
        
        CCSprite *wreck = [CCSprite spriteWithSpriteFrameName:@"Rocket2 Stuck 01.png"];
        [self addChild:wreck z:3];
        wreck.position = CGPointMake(200, 15);
        [wreck runAction:wreckedAnimation];
        
        // Game over text
		CGSize size = [[CCDirector sharedDirector] winSize];        
        CCSprite *text = [CCSprite spriteWithFile:R_GAME_OVER_TEXT];
        text.position = CGPointMake(size.width * 0.5, size.height * 0.65);
        [self addChild:text z:3];
        
        // Score
        IncrementingText *scoreText = [IncrementingText incrementingText:score font:R_DARK_FONT alignment:kCenterAligned isTime:NO];
        scoreText.position =  CGPointMake(size.width * 0.5f, size.height * 0.5f);
        [self addChild:scoreText z:3];

        // Add buttons
        [self addButtons];
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

- (void) addButtons
{
    restartIcon_ = [[CCSprite spriteWithFile:R_RESTART_ICON] retain];
    stageIcon_ = [[CCSprite spriteWithFile:R_STAGE_SELECTION_ICON] retain];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    restartIcon_.position = ccp(220, ES_RESTART_REL_Y * size.height);
    stageIcon_.position = ccp(265, ES_STAGE_REL_Y * size.height);
    
    AnimatedButton *restartButton = [AnimatedButton buttonWithImage:R_RESTART_TEXT target:self selector:@selector(restart)];
    AnimatedButton *stageButton = [AnimatedButton buttonWithImage:R_STAGE_SELECTION_TEXT target:self selector:@selector(stageSelect)];
    restartButton.position = ccp(0.5 * size.width, ES_RESTART_REL_Y * size.height);
    stageButton.position = ccp(0.5 * size.width, ES_STAGE_REL_Y * size.height);
    
    [self addChild:restartIcon_ z:4];
    [self addChild:stageIcon_ z:4];
    [self addChild:restartButton z:4];
    [self addChild:stageButton z:4];    
}

- (void) initActions
{
    CCActionInterval *spinOnce = [CCRotateBy actionWithDuration:ES_RESTART_ROTATE_TIME angle:-360];
    CCAction *spin = [CCRepeatForever actionWithAction:spinOnce];
    [restartIcon_ runAction:spin];
    
    CGFloat duration = 0.05;
    CGFloat delay = 0.3;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:ES_BUTTON_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:ES_BUTTON_SCALE_BIG];    
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
