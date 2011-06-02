//
//  StoryScene.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class GameScene;

@interface StoryScene : CCScene {
 
    NSString *sceneName_;
    
    NSUInteger sceneNum_;
    
    NSUInteger endNum_;
    
    GameScene *gameScene_;
    
    BOOL sceneLocked_;
}

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum;

- (id) initWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum;

- (void) nextScene;

@end
