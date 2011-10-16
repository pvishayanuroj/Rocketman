//
//  PauseLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class AnimatedButton;

/*
 * Layer that is active when the game is paused
 */
@interface PauseLayer : CCLayer {
    
    BOOL isPaused_;
    
    CCMenuItemSprite *button_;
    
    CCSprite *restartIcon_;
    
    CCSprite *stageIcon_;    
    
    AnimatedButton *restartButton_;
    
    AnimatedButton *stageButton_;    
}

- (void) addButtons;

- (void) initActions;

- (void) removeButtons;

- (void) restart;

- (void) stageSelect;

@end
