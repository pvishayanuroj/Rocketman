//
//  StoryManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class StoryScene;

/**
 * A singleton class to handle loading and playing cutscenes
 */
@interface StoryManager : CCNode {
 
    /** Stores all the dynamic elements for this cutscene indexed by scene number, stored as an array */
    NSMutableDictionary *storyElements_;
    
    /** Stores all the timings for each scene of this cutscene */
    NSMutableDictionary *sceneTiming_;
    
    /** Stores all the transitions made for this cutscene */
    NSMutableDictionary *sceneTransitions_;
    
    /** The cutscene name */
    NSString *sceneName_;
    
    /** The current scene number of this cutscene */
    NSUInteger sceneNum_;
    
    /** The total number of scenes for this cutscene */
    NSUInteger endSceneNum_;
    
    /** Reference to the current scene */
    StoryScene *currentScene_;
}

/** Singleton getter */
+ (StoryManager *) storyManager;

+ (void) purgeStoryManager;

/** Will start playing the specified cutscene */
- (void) beginCutscene:(NSString *)cutscene;

/** Used to cleanup memory at the end of every cutscene */
- (void) endCutscene;

/** Called by each story scene when it's time has elapsed */
- (void) nextScene;

/** Method for reading from the cinematics file to load the data for a specified cutscene */
- (void) loadSceneFile:(NSString *)filename forScene:(NSString *)sceneName;

/** Method to perform different types of transitions between cutscenes */
- (void) performTransition:(NSString *)type scene:(StoryScene *)scene;

/** Hardcoded method to loading dynamic elements for the intro cutscene */
- (void) initIntroStoryElements;

@end
