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
#import "HUDDelegate.h"

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
@interface GameManager : CCNode <GameLayerDelegate, HUDDelegate> {
 
    GameLayer *gameLayer_;
    
    HUDLayer *hudLayer_;
    
    PauseLayer *pauseLayer_;
    
    DialogueLayer *dialogueLayer_;
    
    Rocket *rocket_;
    
    Notification *notification_;
}

@property (nonatomic, readonly) Rocket *rocket;

/** Returns the reference to the game manager singleton */
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

/** Method to tell the game layer to add an doodad */
- (void) addDoodad:(DoodadType)type pos:(CGPoint)pos;

- (void) setNumCats01:(NSUInteger)numCats;

- (void) setNumCats02:(NSUInteger)numCats;

- (void) setNumBoosts:(NSUInteger)numBoosts;

- (void) setTilt:(CGFloat)tilt;

- (void) showCombo:(NSUInteger)comboNum;

- (void) addToDialogueLayer:(CCNode *)dialogue;

- (Rocket *) getRocket;

- (BOOL) isRocketInvincible;

- (void) rocketCollision;

/** Sets up the notifications object for this level */
- (void) initNotifications:(NSUInteger)levelNum;

/** Full game pause except pause layer */
- (void) pause;

/** Full game resume counterpart of pause */
- (void) resume;

/** 
 * Pauses gameplay with the exception of the dialogue layer
 * Used to show dialogue messages
 */
- (void) dialoguePause;

/** Resume gameplay counterpart of dialogue pause */
- (void) dialogueResume;

/** Pauses gameplay but leaves buttons and screen touches active */
- (void) notificationPause;

/** Resume gameplay counterpart of notification pause */
- (void) notificationResume;

/** Method to reset all the static counters of all obstacles */
- (void) resetCounters;

@end

