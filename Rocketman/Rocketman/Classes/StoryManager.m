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
#import "GameStateManager.h"
    
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
        
        currentScene_ = nil;
        
	}
	return self;
}

- (void) dealloc
{	
	[super dealloc];
}

#pragma mark - Main Methods

- (void) beginCutscene:(NSString *)cutscene
{
    // Allocate storage
    storyElements_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
    sceneTiming_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
    sceneTransitions_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];    
    
    sceneName_ = [cutscene retain];
    [self loadSceneFile:@"Cinematics" forScene:cutscene];
    
    // Dynamic element loading (hardcoded for now)
    if ([cutscene isEqualToString:@"Intro"]) {
        [self initIntroStoryElements];
    }
    else {
        // Nothing
    }
    
    // Start playing
    [self nextScene];
}

- (void) endCutscene
{
    // Cleanup
    [sceneName_ release];
    sceneName_ = nil;
    
    [currentScene_ stopAllActions];
    [currentScene_ release];
    currentScene_ = nil;
    
    [storyElements_ release];
    [sceneTiming_ release];
    [sceneTransitions_ release];    
    
    // Tell the GSM we're done
    [[GameStateManager gameStateManager] endStory];
}

- (void) nextScene
{    
    sceneNum_++;
    
    // If we've reached the end of the sequence, start the game
    if (sceneNum_ > endSceneNum_) {
        [self endCutscene];
    }
    // Otherwise go to the next scene
    else {
        // Determine scene duration
        NSString *key = [NSString stringWithFormat:@"%02d", sceneNum_];
        CGFloat duration = [[sceneTiming_ objectForKey:key] floatValue];
        
        // Determine scene transition 
        NSString *transitionType = [sceneTransitions_ objectForKey:key];
        
        // Setup the scene and transition
        [currentScene_ release];
        currentScene_ = [[StoryScene storyWithName:sceneName_ num:sceneNum_ duration:duration] retain];    
        [self performTransition:transitionType scene:currentScene_];
        
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

- (void) loadSceneFile:(NSString *)filename forScene:(NSString *)sceneName
{
    // Parse cinematics file
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
	NSDictionary *cutscenes = [NSDictionary dictionaryWithContentsOfFile:path];    
    NSDictionary *sceneInfo = [cutscenes objectForKey:sceneName];
    NSArray *scenes = [sceneInfo objectForKey:@"Scene"];
    
    // Set the total number of scenes so we know when to stop
    sceneNum_ = 0;
    endSceneNum_ = [scenes count];
    
    NSUInteger count = 1;
    // For each scene, get the timing and any other instructions
    for (NSDictionary *scene in scenes) {
        // Get timing
        NSString *key = [NSString stringWithFormat:@"%02d", count];
        NSNumber *timing = [scene objectForKey:@"Timing"];
        [sceneTiming_ setObject:timing forKey:key];
        
        // Get transition type
        NSString *transition = [scene objectForKey:@"Transition"];
        [sceneTransitions_ setObject:transition forKey:key];
        count++;
    }
}

- (void) performTransition:(NSString *)type scene:(StoryScene *)scene
{
    if ([type isEqualToString:@"Instant"]) {
        [[CCDirector sharedDirector] replaceScene:scene];                
    }
    else if ([type isEqualToString:@"Fade"]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];        
    }
    else {
        NSAssert(NO, ([NSString stringWithFormat:@"Invalid transition type: %@", type]));
    }
}

#pragma mark - Custom Initializers

// Where we add the custom dynamic elements
- (void) initIntroStoryElements
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

@end
