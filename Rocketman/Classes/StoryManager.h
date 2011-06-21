//
//  StoryManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class StoryScene;

@interface StoryManager : CCNode {
 
    NSMutableDictionary *storyElements_;
    
    NSMutableDictionary *sceneTiming_;
    
    NSString *sceneName_;
    
    NSUInteger sceneNum_;
    
    NSUInteger endSceneNum_;
    
    StoryScene *currentScene_;
}

+ (StoryManager *) storyManager;

+ (void) purgeStoryManager;

- (void) initStoryElements;

- (void) loadSceneTimings:(NSString *)filename forScene:(NSString *)sceneName;

- (void) nextScene;

- (void) startGame;

@end
