//
//  MainMenuLayer.m
//  Rocketman
//
//  Created by Jamorn Ho on 5/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameScene.h"
#import "StoryScene.h"

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
        
        CCMenuItemSprite *menuButton1 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"play_button.png"] selectedSprite:[CCSprite spriteWithFile:@"play_button.png"] target:self selector:@selector(startGame)];
        CCMenuItemSprite *menuButton2 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"help_button.png"] selectedSprite:[CCSprite spriteWithFile:@"help_button.png"] target:self selector:@selector(viewHighScore)];
        CCMenuItemSprite *menuButton3 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"scores_button.png"] selectedSprite:[CCSprite spriteWithFile:@"scores_button.png"] target:self selector:@selector(viewCredits)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuButton1, menuButton2, menuButton3, nil];
        [menu alignItemsVerticallyWithPadding:40];
        
        [self addChild:backgroundImage z:0];
        [self addChild:menu z:1];
        
	}
	return self;
}

- (void) startGame {
    
    StoryScene *scene = [StoryScene storyWithName:@"Intro" num:1 endNum:5];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
    
}

- (void) viewHighScore {
    
}

- (void) viewCredits {
    
}

- (void) dealloc {
    [super dealloc];
}


@end
