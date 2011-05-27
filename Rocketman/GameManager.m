//
//  GameManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameManager.h"

// For singleton
static GameManager *_gameManager = nil;

@implementation GameManager

//@synthesize gameLayer = gameLayer_;

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
        
	}
	return self;
}

- (void) dealloc
{	
	[gameLayer_ release];
	
	[super dealloc];
}

- (void) registerGameLayer:(GameLayer *)gameLayer
{
	NSAssert(gameLayer_ == nil, @"Trying to register a Game Layer when one already exists");
	gameLayer_ = gameLayer;
	[gameLayer_ retain];
}

- (void) rocketBurn
{
    
    
}

@end
