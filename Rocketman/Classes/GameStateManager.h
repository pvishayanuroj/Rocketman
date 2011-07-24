//
//  GameStateManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface GameStateManager : NSObject {

    NSUInteger lastUnlockedLevel_;    
    
}

@property (nonatomic, readonly) NSUInteger lastUnlockedLevel;

+ (GameStateManager *) gameStateManager;

+ (void) purgeGameStateManager;

- (void) endStory;

- (void) startGame;

@end
