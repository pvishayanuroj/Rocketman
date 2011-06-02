//
//  StorySceneWithCat.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryScene.h"

@interface StorySceneWithCat : StoryScene {
    
    NSUInteger subSceneNum_;
    
}

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum subNum:(NSUInteger)subNum;

- (id) initWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum subNum:(NSUInteger)subNum;

@end
