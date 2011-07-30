//
//  GameStateManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

/**
 * The GSM is in charge of deciding which scene is shown and in what order.
 * All scenes start and end with calls from and to the GSM
 */
@interface GameStateManager : NSObject {

    CCScene *currentGame_;

    NSUInteger currentLevel_;
    
    NSUInteger lastUnlockedLevel_;    
    
}

+ (GameStateManager *) gameStateManager;

+ (void) purgeGameStateManager;

- (void) startGameWithLevel:(NSUInteger)levelNum;

- (void) showWorldMap;

- (void) showGameOver:(NSUInteger)levelNum score:(NSUInteger)score;

- (void) endGame:(NSUInteger)score;

- (void) endStory;

- (void) stageSelectedFromMap:(NSUInteger)levelNum;

- (void) restartFromGameOver;

- (void) stageSelectFromGameOver;

@end
