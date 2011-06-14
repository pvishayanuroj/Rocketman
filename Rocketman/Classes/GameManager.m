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
        
	}
	return self;
}

- (void) dealloc
{	
	[gameLayer_ release];
    [hudLayer_ release];
	
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

#pragma mark - Game Layer Methods

- (void) addShell:(CGPoint)pos
{
    [gameLayer_ addShell:pos];
}

#pragma mark - HUD Methods

- (void) setNumCats:(NSUInteger)numCats
{
    [hudLayer_ setNumCats:numCats];
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

@end
