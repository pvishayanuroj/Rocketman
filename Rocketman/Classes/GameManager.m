//
//  GameManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameManager.h"
#import "GameLayer.h"
#import "HUDLayer.h"
#import "PauseLayer.h"
#import "CCNode+PauseResume.h"

// For singleton
static GameManager *_gameManager = nil;

@implementation GameManager

#pragma mark - Object Lifecycle

+ (GameManager *) gameManager
{
	if (!_gameManager)
		_gameManager = [[self alloc] init];
	
	return _gameManager;
}

+ (id) alloc
{
	NSAssert(_gameManager == nil, @"Attempted to allocate a second instance of a Game Manager singleton.");
	return [super alloc];
}

+ (void) purgeGameManager
{
	[_gameManager release];
	_gameManager = nil;
}

- (id) init
{
	if ((self = [super init])) {
        
		gameLayer_ = nil;
        hudLayer_ = nil;
        pauseLayer_ = nil;
        
	}
	return self;
}

- (void) dealloc
{	
    NSLog(@"Game Manager dealloc'd");
    
	[gameLayer_ release];
    [hudLayer_ release];
    [pauseLayer_ release];
    gameLayer_ = nil;
    hudLayer_ = nil;
    pauseLayer_ = nil;
	
	[super dealloc];
}

#pragma mark - Registration Methods

- (void) registerGameLayer:(GameLayer *)gameLayer
{
	NSAssert(gameLayer_ == nil, @"Trying to register a Game Layer when one already exists");
	gameLayer_ = gameLayer;
	[gameLayer_ retain];
}

- (void) registerHUDLayer:(HUDLayer *)hudLayer
{
	NSAssert(hudLayer_ == nil, @"Trying to register a HUD Layer when one already exists");
	hudLayer_ = hudLayer;
	[hudLayer_ retain];
}

- (void) registerPauseLayer:(PauseLayer *)pauseLayer
{
	NSAssert(pauseLayer_ == nil, @"Trying to register a Pause Layer when one already exists");
	pauseLayer_ = pauseLayer;
	[pauseLayer_ retain];
}

#pragma mark - Game Layer Methods

- (void) addShell:(CGPoint)pos
{
    [gameLayer_ addObstacle:kShell pos:pos];
}

- (void) addTurtling:(CGPoint)pos
{
    [gameLayer_ addObstacle:kTurtling pos:pos];
}

#pragma mark - HUD Methods

- (void) setNumCats01:(NSUInteger)numCats
{
    [hudLayer_ setNumCats01:numCats];
}

- (void) setNumCats02:(NSUInteger)numCats
{
    [hudLayer_ setNumCats02:numCats];
}

- (void) setNumBoosts:(NSUInteger)numBoosts
{
    [hudLayer_ setNumBoosts:numBoosts];
}

- (void) setHeight:(CGFloat)height
{
    [hudLayer_ setHeight:height];
}

- (void) setSpeed:(CGFloat)speed
{
    [hudLayer_ setSpeed:speed];
}

- (void) setTilt:(CGFloat)tilt
{
    [hudLayer_ setTilt:tilt];
}

#pragma mark - Pause / Resume

- (void) pause
{
    [gameLayer_ pauseHierarchy];
    [hudLayer_ pauseHierarchy];
    // Because pauseHiearchy doesn't seem to stop button presses
    [hudLayer_ pause];
}

- (void) resume
{
    [hudLayer_ resume];
    [hudLayer_ resumeHierarchy];
    [gameLayer_ resumeHierarchy];
}

@end
