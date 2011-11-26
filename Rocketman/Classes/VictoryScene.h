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

@interface VictoryScene : CCScene <IncrementingTextDelegate> {
    
    NSArray *scoreLabels_;
    
    CCSprite *stageIcon_;    
    
}

+ (id) victoryScene:(SRSMScore)score;

- (id) initVictoryScene:(SRSMScore)score;

- (NSArray *) createScoreTitles;

- (NSArray *) createScoreLabels:(SRSMScore)score;

- (void) addButtons;

- (void) initActions;

@end
