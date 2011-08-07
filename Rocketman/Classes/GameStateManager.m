//
//  GameStateManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameStateManager.h"
#import "GameManager.h"
#import "AudioManager.h"
#import "MainMenuScene.h"
#import "MapScene.h"
#import "GameScene.h"
#import "EndScene.h"

// For singleton
static GameStateManager *_gameStateManager = nil;

@implementation GameStateManager

#pragma mark - Object Lifecycle

+ (GameStateManager *) gameStateManager
{
	if (!_gameStateManager)
		_gameStateManager = [[self alloc] init];
	
	return _gameStateManager;
}

+ (id) alloc
{
	NSAssert(_gameStateManager == nil, @"Attempted to allocate a second instance of a Game State Manager singleton.");
	return [super alloc];
}

+ (void) purgeGameStateManager
{
	[_gameStateManager release];
	_gameStateManager = nil;
}

- (id) init
{
	if ((self = [super init])) {
            
        lastUnlockedLevel_ = 3;
        
        // Load sounds
        [AudioManager audioManager];                
        
	}
	return self;
}

- (void) dealloc
{		
	[super dealloc];
}

# pragma mark - Start Methods

- (void) startGameWithLevel:(NSUInteger)levelNum
{
    // Initalize a game manager singleton. This should only exist for this stage
    [GameManager gameManager];
    
    currentLevel_ = levelNum;
    CCScene *scene = [GameScene stage:levelNum];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];    
}

- (void) showWorldMap
{
    CCScene *scene = [MapScene mapWithLastUnlocked:lastUnlockedLevel_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];        
}

- (void) showGameOver:(NSUInteger)levelNum score:(NSUInteger)score
{
    CCScene *scene = [EndScene endSceneWithLevel:levelNum score:score];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:scene]];    
}

# pragma mark - Receiver Methods

- (void) endGame:(NSUInteger)score
{    
    // Cleanup GM singleton
    [GameManager purgeGameManager];
    
    [self showGameOver:currentLevel_ score:score];
}

- (void) endStory
{
    [self showWorldMap];
}

- (void) stageSelectedFromMap:(NSUInteger)levelNum
{
    [[AudioManager audioManager] stopMusic];
    [self startGameWithLevel:levelNum];
}

- (void) restartFromGameOver
{
    [[AudioManager audioManager] stopMusic];    
    [self startGameWithLevel:currentLevel_];
}

- (void) stageSelectFromGameOver
{
    [[AudioManager audioManager] stopMusic];    
    [self showWorldMap];
}

@end
