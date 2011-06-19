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
    
}

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num;

- (id) initWithName:(NSString *)name num:(NSUInteger)num;

- (void) startTimer;

- (void) nextScene;

- (void) skip;

@end
