//
//  HighscoreLayer.m
//  Rocketman
//
//  Created by Jamorn Ho on 6/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HighscoreLayer.h"
#import "HighscoreScene.h"
#import "HighscoreManager.h"
#import "MainMenuScene.h"
#import "Constants.h"

@implementation HighscoreLayer

- (id) init {
    if ((self = [super init])) {
        
        NSArray *scores = [HighscoreManager getHighscores];
        
        for (int i=0; i < [scores count]; i++) {
            CCLabelBMFont *label = [CCLabelBMFont labelWithString:[[scores objectAtIndex:[scores count]-i-1] stringValue] fntFile:@"SRSM_font.fnt"];
            label.position = ccp(160, 400 - (i*40));
            
            [self addChild:label];
        }
        
        CCMenuItemImage *backButton = [CCMenuItemImage itemFromNormalImage:@"play_button.png" selectedImage:@"play_button.png" disabledImage:@"play_button.png" target:self selector:@selector(goToMainMenu)];
        
        CCMenuItemImage *resetButton = [CCMenuItemImage itemFromNormalImage:@"help_button.png" selectedImage:@"help_button.png" disabledImage:@"help_button.png" target:self selector:@selector(resetHighscores)];
        
        backButton.position = ccp(0, 0);
        resetButton.position = ccp(200, 0);
        
        CCMenu *menu = [CCMenu menuWithItems:backButton, resetButton, nil];
        
        menu.position = ccp(100, 450);
        
        [self addChild:menu];
    }
    return self;
}

- (void) goToMainMenu {
    MainMenuScene *scene = [MainMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInL transitionWithDuration:0.1f scene:scene]];
}

- (void) resetHighscores {
    [HighscoreManager resetHighscore];
    
    HighscoreScene *scene = [HighscoreScene node];
    [[CCDirector sharedDirector] replaceScene:scene];
}



@end
