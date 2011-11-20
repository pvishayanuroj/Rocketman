//
//  MainMenuLayer.m
//  Rocketman
//
//  Created by Jamorn Ho on 5/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameScene.h"
#import "HighscoreScene.h"
#import "Constants.h"
#import "StoryManager.h"
#import "AnimatedButton.h"
#import "GameStateManager.h"

@implementation MainMenuLayer

/**
 Main Menu layer initialization method
 @returns Returns the created game layer
 */
- (id) init
{
	if ((self = [super init])) {
        
        // Initialize
        [GameStateManager gameStateManager];
        
        CCSprite *backgroundImage = [CCSprite spriteWithFile:R_MENU_SPLASH];
        backgroundImage.anchorPoint = CGPointZero;
        
        AnimatedButton *startButton = [AnimatedButton buttonWithImage:R_PLAY_TEXT target:self selector:@selector(startGame)];
        AnimatedButton *helpButton = [AnimatedButton buttonWithImage:R_HELP_TEXT target:self selector:@selector(viewCredits)];
        AnimatedButton *highScoreButton = [AnimatedButton buttonWithImage:R_SCORES_TEXT target:self selector:@selector(viewHighscore)];        
        
        startButton.position = CGPointMake(120, 260);
        helpButton.position = CGPointMake(120, 200);
        highScoreButton.position = CGPointMake(120, 140);        
        
        [self addChild:backgroundImage z:0];
        [self addChild:startButton z:1];
        [self addChild:helpButton z:1];
        [self addChild:highScoreButton z:1];        
	}
	return self;
}

- (void) startGame 
{
    [[GameStateManager gameStateManager] startGameFromMainMenu];
}

- (void) viewHighscore {
    HighscoreScene *scene = [HighscoreScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:0.1f scene:scene]];
}

- (void) viewCredits {
    
}

- (void) dealloc {
    [super dealloc];
}


@end
