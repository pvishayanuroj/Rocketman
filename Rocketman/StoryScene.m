//
//  StoryScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryScene.h"
#import "StoryLayer.h"
#import "StorySceneWithCat.h"
#import "GameScene.h"

@implementation StoryScene

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum
{
    return [[[self alloc] initWithName:name num:num endNum:endNum] autorelease];
}

- (id) initWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum
{
    if ((self = [super init])) {
        
        sceneName_ = [name retain];
        sceneNum_ = num;
        endNum_ = endNum;
        
        NSString *filename = [NSString stringWithFormat:@"%@ %02d.png", name, num];
        CCSprite *sprite = [CCSprite spriteWithFile:filename];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        StoryLayer *storyLayer = [StoryLayer node];
        [self addChild:storyLayer z:1];
        
        gameScene_ = nil;        
        sceneLocked_ = NO;
        
        // Hide the game preload during the last intro pane
        if (num == endNum) {
            sceneLocked_ = YES;
            [self schedule:@selector(update:) interval:60.0/60.0];
        }
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"%@ dealloc'd", self);
    
    [sceneName_ release];
    [gameScene_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    // Load the game scene
    if (sceneLocked_) {
        gameScene_ = [[GameScene node] retain];
        sceneLocked_ = NO;
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Story Scene %@ %d", sceneName_, sceneNum_];
}    

- (void) nextScene
{
    if (!sceneLocked_) {
        CCScene *scene;
        
        // End of intro sequence
        if (sceneNum_ == endNum_) {
            scene = gameScene_;
        }
        // Special case to show the cat floating up
        else if (sceneNum_ == 1 && [sceneName_ isEqualToString:@"Intro"]) {
            scene = [StorySceneWithCat storyWithName:sceneName_ num:(sceneNum_ + 1) endNum:endNum_ subNum:1];
        }
        // Next intro pane
        else {
            scene = [StoryScene storyWithName:sceneName_ num:(sceneNum_ + 1) endNum:endNum_];
        }
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
    }
}

@end
