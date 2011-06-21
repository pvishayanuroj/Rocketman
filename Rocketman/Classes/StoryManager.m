//
//  StoryManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryManager.h"
#import "StoryScene.h"
#import "SpinningElement.h"
#import "TextElement.h"
#import "MovingElement.h"
#import "GameScene.h"
    
// For singleton
static StoryManager *_storyManager = nil;

@implementation StoryManager

#pragma mark - Object Lifecycle

+ (StoryManager *) storyManager
{
	if (!_storyManager)
		_storyManager = [[self alloc] init];
	
	return _storyManager;
}

+ (id) alloc
{
	NSAssert(_storyManager == nil, @"Attempted to allocate a second instance of a Story Manager singleton.");
	return [super alloc];
}

+ (void) purgeStoryManager
{
	[_storyManager release];
	_storyManager = nil;
}

- (id) init
{
	if ((self = [super init])) {
        
        storyElements_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
        currentScene_ = nil;
        sceneTiming_ = nil;
        
        sceneName_ = [[NSString stringWithString:@"Intro"] retain];
        sceneNum_ = 0;
        endSceneNum_ = 9;
        
        [self initStoryElements];
        [self loadSceneTimings:@"Cinematics" forScene:@"Intro"];

	}
	return self;
}

- (void) dealloc
{	
    [storyElements_ release];
    [currentScene_ release];
    [sceneName_ release];
    [sceneTiming_ release];
    
	[super dealloc];
}

// Where we add the custom dynamic elements
- (void) initStoryElements
{
    StoryElement *element;
    NSMutableArray *array;

    // Scene 5 Cat Animation
    element = [SpinningElement spinningElementAWithFile:@"Intro Cat.png" from:ccp(250, 350) to:ccp(400, 350) duration:2.0];
    array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:element];
    [storyElements_ setObject:array forKey:[NSNumber numberWithUnsignedInt:5]];
    
    // Scene 6 Cat Animation    
    element = [SpinningElement spinningElementBWithFile:@"Intro Cat.png" from:ccp(-30, 10) to:ccp(180, 250) duration:5.0];
    array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:element];
    [storyElements_ setObject:array forKey:[NSNumber numberWithUnsignedInt:6]];
    
    CGSize size = [[CCDirector sharedDirector] winSize];    
    CGPoint halfPos = ccp(size.width * 0.5, size.height * 0.5);
    
    // Scene 7 Text & Phone animation
    array = [NSMutableArray arrayWithCapacity:2];    
    element = [TextElement textElementWithFile:@"Intro 07 Text.png" at:ccp(halfPos.x, size.height*0.7)];
    [array addObject:element];
    element = [MovingElement movingElementWithFile:@"Intro 07 Hand.png" from:ccp(450, 100) to:ccp(200, 100) delay:2.0 duration:1.0];
    [array addObject:element];    
    [storyElements_ setObject:array forKey:[NSNumber numberWithUnsignedInt:7]];
    
    // Scene 8 Text
    element = [TextElement textElementWithFile:@"Intro 08 Text.png" at:halfPos];
    array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:element];
    [storyElements_ setObject:array forKey:[NSNumber numberWithUnsignedInt:8]];    
}

- (void) loadSceneTimings:(NSString *)filename forScene:(NSString *)sceneName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
	NSDictionary *scenes = [NSDictionary dictionaryWithContentsOfFile:path];    
    NSDictionary *sceneInfo = [scenes objectForKey:sceneName];
    sceneTiming_ = [[sceneInfo objectForKey:@"Scene Timing"] retain];
}

- (void) nextScene
{    
    //StoryScene *scene;
    NSString *key;
    CGFloat duration;
    sceneNum_++;
    
    // If we've reached the end of the sequence, start the game
    if (sceneNum_ > endSceneNum_) {
        [self startGame];
    }
    // Otherwise go to the next scene
    else {
        // Determine scene duration
        key = [NSString stringWithFormat:@"%02d", sceneNum_];
        duration = [[sceneTiming_ objectForKey:key] floatValue];
        
        // Setup the scene and transition
        [currentScene_ release];
        currentScene_ = [[StoryScene storyWithName:sceneName_ num:sceneNum_ duration:duration] retain];    
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:currentScene_]];            
        
        // Check if there are any story elements to add
        NSArray *elements = [storyElements_ objectForKey:[NSNumber numberWithUnsignedInteger:sceneNum_]];
        if (elements) {
            for (StoryElement *se in elements) {
                [currentScene_ addChild:se z:1];
                [se play];
            }
        }
        
        // Make sure the scene afterwards will get run
        [currentScene_ startTimer];
    }
}

- (void) startGame
{
    [currentScene_ stopAllActions];
    [currentScene_ release];
    currentScene_ = nil;
    
    CCScene *scene = [GameScene node];        
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];                
}


@end
