//
//  MapLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "MapButtonDelegate.h"

@class AnimatedButton;

@interface MapLayer : CCLayer <MapButtonDelegate> {
    
    CCSprite *rocket_;
    
	CCAction *rocketAnimation_;        
    
    NSUInteger currentLevel_;
    
    NSMutableArray *levelDescs_;
    
    NSMutableArray *buttons_;
    
    NSArray *mapData_;
    
    AnimatedButton *startButton_;
    
    CCLabelBMFont *levelTitle_;   
}

+ (id) map:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;

- (id) initMap:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;

- (void) initActions;

- (void) animateRocket;

- (void) moveRocketTo:(NSUInteger)levelNum;

- (CCActionInterval *) constructMoveFrom:(NSUInteger)from to:(NSUInteger)to;

/** Does not allow user input for the map screen */
- (void) lockInput;

/** Allows user input for the map screen */
- (void) unlockInput;

- (void) hideStart;

- (void) showStart;

@end
