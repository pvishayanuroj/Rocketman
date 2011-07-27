//
//  GameStateManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameStateManager.h"
#import "AudioManager.h"
#import "MainMenuScene.h"
#import "MapScene.h"
#import "GameScene.h"
#import "EndScene.h"

// For singleton
static GameStateManager *_gameStateManager = nil;

@implementation GameStateManager

@synthesize lastUnlockedLevel = lastUnlockedLevel_;

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

# pragma mark - Transitions

- (void) endStory
{
    CCScene *mapScene = [MapScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:mapScene]];                    
}

- (void) startGame
{
    CCScene *scene = [GameScene node];        
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];    
}

- (void) endLevel
{
    CCScene *scene = [EndScene endSceneWithLevel:1 score:10000];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];    
}

@end
