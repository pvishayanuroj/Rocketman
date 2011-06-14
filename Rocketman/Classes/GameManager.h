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

@interface GameManager : CCNode {
 
    GameLayer *gameLayer_;
    
    HUDLayer *hudLayer_;
}

+ (GameManager *) gameManager;

- (void) registerGameLayer:(GameLayer *)gameLayer;

- (void) registerHUDLayer:(HUDLayer *)hudLayer;

- (void) addShell:(CGPoint)pos;

- (void) setNumCats:(NSUInteger)numCats;

- (void) setNumBoosts:(NSUInteger)numBoosts;

- (void) setHeight:(CGFloat)height;

- (void) setSpeed:(CGFloat)speed;

- (void) setTilt:(CGFloat)tilt;

@end

