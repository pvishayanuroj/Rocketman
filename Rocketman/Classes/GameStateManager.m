//
//  GameStateManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameStateManager.h"
#import "GameManager.h"
#import "DataManager.h"
#import "StoryManager.h"
#import "AudioManager.h"
#import "MainMenuScene.h"
#import "MapScene.h"
#import "GameScene.h"
#import "LoadScene.h"
#import "EndScene.h"
#import "MainMenuScene.h"

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
            
        currentLevel_ = 6;
        lastUnlockedLevel_ = 6;
        
        // Load sounds
        [AudioManager audioManager];      
        
        // Load animations
        [[DataManager dataManager] animationLoader:@"sheet01_animations" spriteSheetName:@"sheet01"];
        
        // Load all game data
        [DataManager dataManager];
        
	}
	return self;
}

- (void) dealloc
{		
	[super dealloc];
}

# pragma mark - Start Methods

- (void) showMainMenu
{
    CCScene *scene = [MainMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];    
}

- (void) startGameWithLevel:(NSUInteger)levelNum
{
    // Initalize a game manager singleton. This should only exist for this stage
    [GameManager gameManager];
    
    CCScene *scene = [LoadScene stage:levelNum];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];    
}

- (void) showWorldMap
{
    CCScene *scene = [MapScene mapWithLastUnlocked:lastUnlockedLevel_ currentLevel:currentLevel_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];        
}

- (void) showGameOver:(NSUInteger)levelNum score:(NSUInteger)score
{
    CCScene *scene = [EndScene endSceneWithLevel:levelNum score:score];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:scene]];    
}

# pragma mark - Receiver Methods

- (void) startGameFromMainMenu
{
    [[StoryManager storyManager] beginCutscene:@"Intro"];
}

- (void) endGame:(NSUInteger)score
{    
    // Cleanup GM singleton
    [GameManager purgeGameManager];
    
    [self showGameOver:currentLevel_ score:score];
}

- (void) endStory
{
    //[self startGameWithLevel:1];
    [self showWorldMap];
}

- (void) menuFromMap
{
    [self showMainMenu];
}

- (void) stageSelectedFromMap:(NSUInteger)levelNum
{
    currentLevel_ = levelNum;
    [[AudioManager audioManager] stopMusic];    
    [self startGameWithLevel:levelNum];
}

- (void) restartFromPause
{
    [[AudioManager audioManager] stopMusic];    
    // Very important to do this, since the accelerometer singleton is holding a ref to us
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];    
    [GameManager purgeGameManager];
    [self startGameWithLevel:currentLevel_];
}

- (void) stageSelectFromPause
{
    [[AudioManager audioManager] stopMusic]; 
    // Very important to do this, since the accelerometer singleton is holding a ref to us
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];    
    [GameManager purgeGameManager];    
    [self showWorldMap];
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
