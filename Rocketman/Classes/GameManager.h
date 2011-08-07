//
//  GameManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class GameLayer;
@class HUDLayer;
@class PauseLayer;
@class DialogueLayer;

@interface GameManager : CCNode {
 
    GameLayer *gameLayer_;
    
    HUDLayer *hudLayer_;
    
    PauseLayer *pauseLayer_;
    
    DialogueLayer *dialogueLayer_;
}

+ (GameManager *) gameManager;

+ (void) purgeGameManager;

- (void) registerGameLayer:(GameLayer *)gameLayer;

- (void) registerHUDLayer:(HUDLayer *)hudLayer;

- (void) registerPauseLayer:(PauseLayer *)pauseLayer;

- (void) registerDialogueLayer:(DialogueLayer *)dialogueLayer;

- (void) addShell:(CGPoint)pos;

- (void) setNumCats01:(NSUInteger)numCats;

- (void) setNumCats02:(NSUInteger)numCats;

- (void) setNumBoosts:(NSUInteger)numBoosts;

- (void) setHeight:(CGFloat)height;

- (void) setSpeed:(CGFloat)speed;

- (void) setTilt:(CGFloat)tilt;

- (void) showCombo:(NSUInteger)comboNum;

- (void) pause;

- (void) resume;

- (void) dialoguePause;

- (void) dialogueResume;

@end

