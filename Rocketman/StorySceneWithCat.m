//
//  StorySceneWithCat.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StorySceneWithCat.h"


@implementation StorySceneWithCat

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum subNum:(NSUInteger)subNum
{
    return [[[self alloc] initWithName:name num:num endNum:endNum subNum:subNum] autorelease];
}

- (id) initWithName:(NSString *)name num:(NSUInteger)num endNum:(NSUInteger)endNum subNum:(NSUInteger)subNum
{
    if ((self = [super initWithName:name num:num endNum:endNum])) {
        
        subSceneNum_ = subNum;
        
        CCSprite *cat = [CCSprite spriteWithFile:@"Flying Cat.png"];
        [self addChild:cat];
        
        switch (subNum) {
            case 1:
                cat.position = ccp(200, 100);
                break;
            case 2:
                cat.position = ccp(200, 200);                
                break;
            case 3:
                cat.position = ccp(200, 300);                
                break;
            default:
                NSAssert(NO, @"Incorrect sub scene number for Story Scene With Cat");
        }
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Story Scene With Cat %@ %d %d", sceneName_, sceneNum_, subSceneNum_];
}    

- (void) nextScene
{
    CCScene *scene;
    
    // End of intro sequence
    if (subSceneNum_ == 3) {
        scene = [StoryScene storyWithName:sceneName_ num:(sceneNum_+ 1) endNum:endNum_];
    }
    // Next sub intro pane
    else {
        scene = [StorySceneWithCat storyWithName:sceneName_ num:sceneNum_ endNum:endNum_ subNum:(subSceneNum_ + 1)];
    }
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];
}

@end
