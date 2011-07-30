//
//  PauseLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

/*
 * Layer that is active when the game is paused
 */
@interface PauseLayer : CCLayer {
    
    BOOL isPaused_;
    
    CCMenuItemSprite *button_;
    
}

@end
