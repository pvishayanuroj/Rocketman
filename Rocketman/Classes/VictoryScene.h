//
//  VictoryScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "IncrementingTextDelegate.h"

@class VictoryLayer;

@interface VictoryScene : CCScene <IncrementingTextDelegate> {
    
    CCSprite *timeTitle_;
    
    CCSprite *comboTitle_;
    
    CCSprite *enemiesTitle_;
    
    SRSMScore score_;
    
    NSUInteger level_;
    
    /** For detecting touches */
    VictoryLayer *layer_;
}

+ (id) victorySceneWithLevel:(NSUInteger)level score:(SRSMScore)score;

- (id) initVictoryScene:(NSUInteger)level score:(SRSMScore)score;

- (void) createTextCallback:(id)sender data:(void *)data;

- (void) createText:(ScoreCategory)scoreCategory;

- (void) placeMedalAndRecord:(ScoreCategory)scoreCategory score:(NSInteger)score;

- (void) placeMedal:(ScoreCategory)scoreCategory medal:(MedalType)medal;

@end
