//
//  VictoryScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "VictoryScene.h"
#import "IncrementingText.h"
#import "FallingRocket.h"
#import "GameStateManager.h"
#import "AnimatedButton.h"
#import "ScoreManager.h"

@implementation VictoryScene

static const CGFloat VS_MEDAL_X = 0.10f;
static const CGFloat VS_CLEARED_TITLE_Y = 0.88f;
static const CGFloat VS_SCORE_TITLE_X = 0.25f;
static const CGFloat VS_SCORE_VALUE_X = 0.35f;
static const CGFloat VS_TIME_TITLE_Y = 0.68f;
static const CGFloat VS_TIME_VALUE_Y = 0.60f;
static const CGFloat VS_COMBO_TITLE_Y = 0.50f;
static const CGFloat VS_COMBO_VALUE_Y = 0.42f;
static const CGFloat VS_ENEMIES_TITLE_Y = 0.32f;
static const CGFloat VS_ENEMIES_VALUE_Y = 0.24f;

// Starting position of the rocket
static const CGFloat VS_ROCKET_START_X = 200.0f;
static const CGFloat VS_ROCKET_START_Y = 450.0f;

+ (id) victorySceneWithLevel:(NSUInteger)level score:(SRSMScore)score
{
    return [[[self alloc] initVictoryScene:level score:score] autorelease];
}

- (id) initVictoryScene:(NSUInteger)level score:(SRSMScore)score
{
    if ((self = [super init])) {
        
        NSLog(@"time: %6.4f", score.elapsedTime);
        score_ = score;
        level_ = level;
        CGSize size = [[CCDirector sharedDirector] winSize];        
        
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
        
        CCSprite *clearedTitle = [CCSprite spriteWithFile:R_STAGE_CLEARED_TEXT];
        clearedTitle.position = CGPointMake(size.width * 0.5f, size.height * VS_CLEARED_TITLE_Y);
        [self addChild:clearedTitle z:3];
        
        timeTitle_ = [[CCSprite spriteWithFile:R_TIME_TAKEN_TEXT] retain];
        comboTitle_ = [[CCSprite spriteWithFile:R_MAX_COMBO_TEXT] retain];
        enemiesTitle_ = [[CCSprite spriteWithFile:R_ENEMIES_DESTROYED_TEXT] retain];
        timeTitle_.position = CGPointMake(size.width * VS_SCORE_TITLE_X, size.height * VS_TIME_TITLE_Y);
        comboTitle_.position = CGPointMake(size.width * VS_SCORE_TITLE_X, size.height * VS_COMBO_TITLE_Y);
        enemiesTitle_.position = CGPointMake(size.width * VS_SCORE_TITLE_X, size.height * VS_ENEMIES_TITLE_Y);        
        timeTitle_.anchorPoint = CGPointMake(0.0f, 0.5f);
        comboTitle_.anchorPoint = CGPointMake(0.0f, 0.5f);
        enemiesTitle_.anchorPoint = CGPointMake(0.0f, 0.5f);        
        timeTitle_.visible = NO;
        comboTitle_.visible = NO;
        enemiesTitle_.visible = NO;
        [self addChild:timeTitle_ z:3];
        [self addChild:comboTitle_ z:3];
        [self addChild:enemiesTitle_ z:3];
        
        // Add the falling rocket
        FallingRocket *rocket = [FallingRocket fallingRocket];
        rocket.position = CGPointMake(VS_ROCKET_START_X, VS_ROCKET_START_Y);
        [self addChild:rocket z:2];
        
        
        
        // Show the first score
        [self createText:kScoreTimeTaken];
    }
    return self;
}

- (void) dealloc
{
    [timeTitle_ release];
    [comboTitle_ release];
    [enemiesTitle_ release];
    
    [super dealloc];
}

- (void) createTextCallback:(id)sender data:(void *)data
{
    [self createText:(int)data];
}

- (void) createText:(ScoreCategory)scoreCategory
{
    CGSize size = [[CCDirector sharedDirector] winSize];  
    IncrementingText *text;
    
    if (scoreCategory == kScoreTimeTaken) {
        timeTitle_.visible = YES;
        NSInteger elapsedTime = round(score_.elapsedTime * 10);    
        text = [IncrementingText incrementingText:elapsedTime font:R_DARK_FONT alignment:kLeftAligned isTime:YES];
        text.unitID = kScoreTimeTaken;
        text.position = CGPointMake(size.width * VS_SCORE_VALUE_X, size.height * VS_TIME_VALUE_Y);        
    }
    else if (scoreCategory == kScoreEnemiesDestroyed) {
        enemiesTitle_.visible = YES;        
        text = [IncrementingText incrementingText:score_.numEnemiesKilled font:R_DARK_FONT alignment:kLeftAligned isTime:NO];    
        text.unitID = kScoreEnemiesDestroyed;
        text.position = CGPointMake(size.width * VS_SCORE_VALUE_X, size.height * VS_ENEMIES_VALUE_Y);        
    }
    else if (scoreCategory == kScoreMaxCombo) {
        comboTitle_.visible = YES;        
        text = [IncrementingText incrementingText:score_.maxCombo font:R_DARK_FONT alignment:kLeftAligned isTime:NO];
        text.unitID = kScoreMaxCombo;
        text.position = CGPointMake(size.width * VS_SCORE_VALUE_X, size.height * VS_COMBO_VALUE_Y);        
    }

    text.delegate = self;
    [self addChild:text z:3];    
}

- (void) incrementationDone:(IncrementingText *)text
{
    CCAction *nextScore;
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0f];
    CCCallFuncND *nextText = nil;
    switch (text.unitID) {
        case kScoreTimeTaken:
            [self placeMedalAndRecord:text.unitID score:round(score_.elapsedTime)];
            nextText = [CCCallFuncND actionWithTarget:self selector:@selector(createTextCallback:data:) data:(void *)kScoreMaxCombo];
            nextScore = [CCSequence actions:delay, nextText, nil];
            [self runAction:nextScore];            
            break;
        case kScoreMaxCombo:
            [self placeMedalAndRecord:text.unitID score:score_.maxCombo];
            nextText = [CCCallFuncND actionWithTarget:self selector:@selector(createTextCallback:data:) data:(void *)kScoreEnemiesDestroyed];            
            nextScore = [CCSequence actions:delay, nextText, nil];
            [self runAction:nextScore];            
            break;
        case kScoreEnemiesDestroyed:
            [self placeMedalAndRecord:text.unitID score:score_.numEnemiesKilled];
            break;
        default:
            break;
    }
}

- (void) placeMedalAndRecord:(ScoreCategory)scoreCategory score:(NSInteger)score
{
    // Check if record is broken
    if ([ScoreManager checkAndStoreRecord:scoreCategory level:level_ score:score]) {
        
    }
    MedalType medal = [ScoreManager checkBenchmark:scoreCategory level:level_ score:score];
    [self placeMedal:scoreCategory medal:medal];
}

- (void) placeMedal:(ScoreCategory)scoreCategory medal:(MedalType)medal
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *sprite;
    
    switch (medal) {
        case kMedalBronze:
            sprite = [CCSprite spriteWithSpriteFrameName:@"Bronze Medal.png"];
            break;
        case kMedalSilver:
            sprite = [CCSprite spriteWithSpriteFrameName:@"Silver Medal.png"];
            break;
        case kMedalGold:
            sprite = [CCSprite spriteWithSpriteFrameName:@"Gold Medal.png"];
            break;
        default:
            break;
    }
    
    switch (scoreCategory) {
        case kScoreTimeTaken:
            sprite.position = CGPointMake(size.width * VS_MEDAL_X, size.height * VS_TIME_TITLE_Y);
            break;
        case kScoreEnemiesDestroyed:
            sprite.position = CGPointMake(size.width * VS_MEDAL_X, size.height * VS_ENEMIES_TITLE_Y);
            break;
        case kScoreMaxCombo:
            sprite.position = CGPointMake(size.width * VS_MEDAL_X, size.height * VS_COMBO_TITLE_Y);
            break;
        default:
            break;
    }
    
    [self addChild:sprite z:3];
}

- (void) stageSelect
{
    [[GameStateManager gameStateManager] stageSelectFromGameOver];
}

@end
