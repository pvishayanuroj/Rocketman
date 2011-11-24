//
//  GameStateManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

/**
 * The GSM is in charge of deciding which scene is shown and in what order.
 * All scenes start and end with calls from and to the GSM
 */
@interface GameStateManager : NSObject {

    NSUInteger currentLevel_;
    
    NSUInteger lastUnlockedLevel_;    
    
}

/** 
 * Static method to get a reference to the current GSM singleton 
 * and to create one if it doesn't exist 
 */
+ (GameStateManager *) gameStateManager;

/** Static method to clear GSM singleton */
+ (void) purgeGameStateManager;

/** Goes to the main menu */
- (void) showMainMenu;

/** Method to start the game play */
- (void) startGameWithLevel:(NSUInteger)levelNum;

/** Method to show the world map */
- (void) showWorldMap;

/** Method to show the victory screen */
- (void) showStageCleared:(NSUInteger)levelNum score:(SRSMScore)score;

/** Method to display a game over screen */
- (void) showGameOver:(NSUInteger)levelNum score:(NSUInteger)score;

/** Called when a level ends */
- (void) endGame:(NSUInteger)score;

/** Called when a level is cleared */
- (void) endGameWithWin:(SRSMScore)score;

/** Called when a cutscene ends */
- (void) endStory;

/** Called when start is pressed from the main menu */
- (void) startGameFromMainMenu;

/** Called when a user presses menu from the world map */
- (void) menuFromMap;

/** Called when user selects a stage from the world map */
- (void) stageSelectedFromMap:(NSUInteger)levelNum;

/** Called when user selects restart from the pause screen */
- (void) restartFromPause;

/** Called when user selects the world map from the pause screen */
- (void) stageSelectFromPause;

/** Called when user selects restart from the game over screen */
- (void) restartFromGameOver;

/** Called when user selects the world map from the game over screen */
- (void) stageSelectFromGameOver;

@end
