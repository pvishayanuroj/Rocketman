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

@implementation MainMenuLayer

/**
 Main Menu layer initialization method
 @returns Returns the created game layer
 */
- (id) init
{
	if ((self = [super init])) {
        
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"menu_splash.png"];
        backgroundImage.anchorPoint = CGPointZero;
        
        AnimatedButton *startButton = [AnimatedButton buttonWithImage:@"play_button.png" target:self selector:@selector(startGame)];
        AnimatedButton *helpButton = [AnimatedButton buttonWithImage:@"help_button.png" target:self selector:@selector(viewCredits)];
        AnimatedButton *highScoreButton = [AnimatedButton buttonWithImage:@"scores_button.png" target:self selector:@selector(viewHighscore)];        
        
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
    [[StoryManager storyManager] beginCutscene:@"Intro"];
}

- (void) viewHighscore {
    HighscoreScene *scene = [HighscoreScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:SCENE_TRANSITION_DURATION scene:scene]];
}

- (void) viewCredits {
    
}

- (void) dealloc {
    [super dealloc];
}


@end
