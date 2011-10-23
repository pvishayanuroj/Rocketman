//
//  GameManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "GameLayerDelegate.h"

@class GameLayer;
@class HUDLayer;
@class PauseLayer;
@class DialogueLayer;
@class Rocket;
@class Obstacle;
@class Notification;

/** 
 * Singleton that only persists for one stage at a time.
 * Holds references to all layers being shown during gameplay
 * and acts as an interface between them.
 */
@interface GameManager : CCNode <GameLayerDelegate> {
 
    GameLayer *gameLayer_;
    
    HUDLayer *hudLayer_;
    
    PauseLayer *pauseLayer_;
    
    DialogueLayer *dialogueLayer_;
    
    Rocket *rocket_;
    
    Notification *notification_;
}

+ (GameManager *) gameManager;

+ (void) purgeGameManager;

- (void) registerGameLayer:(GameLayer *)gameLayer;

- (void) registerHUDLayer:(HUDLayer *)hudLayer;

- (void) registerPauseLayer:(PauseLayer *)pauseLayer;

- (void) registerDialogueLayer:(DialogueLayer *)dialogueLayer;

- (void) registerRocket:(Rocket *)rocket;

/** Method to tell the game layer to add an obstacle */
- (void) addObstacle:(CGPoint)pos type:(ObstacleType)type;

/** Method to pass an obstacle to add in the game layer */
- (void) addObstacle:(Obstacle *)obstacle;

- (void) setNumCats01:(NSUInteger)numCats;

- (void) setNumCats02:(NSUInteger)numCats;

- (void) setNumBoosts:(NSUInteger)numBoosts;

- (void) setTilt:(CGFloat)tilt;

- (void) showCombo:(NSUInteger)comboNum;

- (void) addToDialogueLayer:(CCNode *)dialogue;

- (Rocket *) getRocket;

- (void) initNotifications:(NSUInteger)levelNum;

/** Full game pause */
- (void) pause;

/** Full game resume */
- (void) resume;

/** 
 * Pauses gameplay with the exception of the dialogue layer
 * Used to show dialogue messages
 */
- (void) dialoguePause;

/** Resume gameplay counterpart of dialogue pause */
- (void) dialogueResume;

/** Method to reset all the static counters of all obstacles */
- (void) resetCounters;

@end

