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
        
        sceneName_ = [[NSString stringWithString:@"Intro"] retain];
        sceneNum_ = 0;
        endSceneNum_ = 9;
        
        [self initStoryElements];

	}
	return self;
}

- (void) dealloc
{	
    [storyElements_ release];
    [sceneName_ release];
    
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
    
    // Scene 7 Text
    element = [TextElement textElementWithFile:@"Intro 07 Text.png" at:halfPos];
    array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:element];
    [storyElements_ setObject:array forKey:[NSNumber numberWithUnsignedInt:7]];
    
    // Scene 8 Text
    element = [TextElement textElementWithFile:@"Intro 08 Text.png" at:halfPos];
    array = [NSMutableArray arrayWithCapacity:1];
    [array addObject:element];
    [storyElements_ setObject:array forKey:[NSNumber numberWithUnsignedInt:8]];    
}

- (void) nextScene
{    
    StoryScene *scene;
    sceneNum_++;
    
    // If we've reached the end of the sequence, start the game
    if (sceneNum_ > endSceneNum_) {
        [self startGame];
    }
    // Otherwise go to the next scene
    else {
        scene = [StoryScene storyWithName:sceneName_ num:sceneNum_];    
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];            
        
        // Check if there are any story elements to add
        NSArray *elements = [storyElements_ objectForKey:[NSNumber numberWithUnsignedInteger:sceneNum_]];
        if (elements) {
            for (StoryElement *se in elements) {
                [scene addChild:se];
                [se play];
            }
        }
        
        // Make sure the scene afterwards will get run
        [scene startTimer];
    }
}

- (void) startGame
{
    CCScene *scene = [GameScene node];        
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];                
}


@end
