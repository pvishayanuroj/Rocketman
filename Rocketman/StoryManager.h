//
//  StoryManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface StoryManager : CCNode {
 
    NSMutableDictionary *storyElements_;
    
    NSString *sceneName_;
    
    NSUInteger sceneNum_;
    
    NSUInteger endSceneNum_;
    
}

+ (StoryManager *) storyManager;

+ (void) purgeStoryManager;

- (void) initStoryElements;

- (void) nextScene;

@end
