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
#import "DialogueLayer.h"
#import "Rocket.h"
#import "CCNode+PauseResume.h"
#import "Obstacle.h"
#import "Notification.h"
#import "ObjectHeaders.h"
#import "Button.h"

// For singleton
static GameManager *_gameManager = nil;

@implementation GameManager

@synthesize rocket = rocket_;

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
    NSLog(@"Initializing Game Manager");
    
	if ((self = [super init])) {
        
		gameLayer_ = nil;
        hudLayer_ = nil;
        pauseLayer_ = nil;
        dialogueLayer_ = nil;
        rocket_ = nil;
        notification_ = nil;
        
        [self resetCounters];
	}
	return self;
}

- (void) dealloc
{	
    NSLog(@"Game Manager dealloc'd");
    
	[gameLayer_ release];
    [hudLayer_ release];
    [pauseLayer_ release];
    [dialogueLayer_ release];
    [rocket_ release];
    [notification_ release];
    gameLayer_ = nil;
    hudLayer_ = nil;
    pauseLayer_ = nil;
    dialogueLayer_ = nil;    
    rocket_ = nil;
    notification_ = nil;
    
	[super dealloc];
}

#pragma mark - Registration Methods

- (void) registerGameLayer:(GameLayer *)gameLayer
{
	NSAssert(gameLayer_ == nil, @"Trying to register a Game Layer when one already exists");
	gameLayer_ = [gameLayer retain];
    gameLayer_.delegate = self;
}

- (void) registerHUDLayer:(HUDLayer *)hudLayer
{
	NSAssert(hudLayer_ == nil, @"Trying to register a HUD Layer when one already exists");
	hudLayer_ = [hudLayer retain];
    hudLayer_.delegate = self;
}

- (void) registerPauseLayer:(PauseLayer *)pauseLayer
{
	NSAssert(pauseLayer_ == nil, @"Trying to register a Pause Layer when one already exists");
	pauseLayer_ = [pauseLayer retain];
}

- (void) registerDialogueLayer:(DialogueLayer *)dialogueLayer
{
	NSAssert(dialogueLayer_ == nil, @"Trying to register a Dialogue Layer when one already exists");
	dialogueLayer_ = [dialogueLayer retain];
}

- (void) registerRocket:(Rocket *)rocket
{
    NSAssert(rocket_ == nil, @"Trying to register a Rocket when one already exists");
    rocket_ = [rocket retain];
}

#pragma mark - Delegate Methods

- (void) heightUpdate:(NSInteger)height
{
    [hudLayer_ setHeight:height];    
    [notification_ heightUpdate:height];
}

- (void) speedUpdate:(CGFloat)speed
{
    [hudLayer_ setSpeed:speed];    
}

- (void) obstacleAdded:(Obstacle *)obstacle
{
    [notification_ obstacleAdded:obstacle];
}

- (void) catButtonPressed:(Button *)button
{
    [notification_ buttonClicked:button];
    [gameLayer_ fireCat01];
}

- (void) bombButtonPressed:(Button *)button
{
    [notification_ buttonClicked:button];    
    [gameLayer_ fireCat02];    
}

- (void) slowButtonPressed:(Button *)button
{
    [notification_ buttonClicked:button];    
    [rocket_ showSlow];
}

- (void) boostButtonPressed:(Button *)button
{
    [notification_ buttonClicked:button];    
    [gameLayer_ useBoost];
}

- (void) screenClicked
{  
    [notification_ screenClicked];
}

#pragma mark - Game Layer Methods

- (void) addObstacle:(CGPoint)pos type:(ObstacleType)type
{
    [gameLayer_ addObstacle:type pos:pos];
}

- (void) addObstacle:(Obstacle *)obstacle
{
    [gameLayer_ addObstacle:obstacle];
}

- (void) addDoodad:(DoodadType)type pos:(CGPoint)pos
{
    [gameLayer_ addDoodad:type pos:pos];
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

- (void) setTilt:(CGFloat)tilt
{
    [hudLayer_ setTilt:tilt];
}

#pragma mark - Dialogue Layer Methods

- (void) showCombo:(NSUInteger)comboNum
{
    [dialogueLayer_ showCombo:comboNum];
}

- (void) addToDialogueLayer:(CCNode *)dialogue
{
    [dialogueLayer_ addChild:dialogue];
}

#pragma mark - Rocket methods

- (Rocket *) getRocket
{
    return rocket_;
}

- (BOOL) isRocketInvincible
{
    return rocket_.isInvincible;
}

- (void) rocketCollision
{
    [gameLayer_ slowDown:0.66f];
    [rocket_ showWobbling];
}

- (void) rocketAngelCollide
{
    [rocket_ showHeart];
    [gameLayer_ engageFixedBoost:12 amt:12 rate:0 time:3.0];    
}

#pragma mark - Notification methods

- (void) initNotifications:(NSUInteger)levelNum
{
    notification_ = [[Notification notification:levelNum] retain];
}

#pragma mark - Pause / Resume

- (void) pause
{
    [gameLayer_ pauseHierarchy];
    [dialogueLayer_ pauseHierarchy];    
    [hudLayer_ pauseHierarchy];
    // Because pauseHiearchy doesn't seem to stop button presses
    [hudLayer_ pause];
}

- (void) resume
{
    [hudLayer_ resume];
    [hudLayer_ resumeHierarchy];
    [dialogueLayer_ resumeHierarchy];
    [gameLayer_ resumeHierarchy];
}

- (void) dialoguePause
{
    [gameLayer_ pauseHierarchy];
    [hudLayer_ pauseHierarchy];
    // Because pauseHiearchy doesn't seem to stop button presses
    [hudLayer_ pause];    
}

- (void) dialogueResume
{
    [hudLayer_ resume];
    [hudLayer_ resumeHierarchy];
    [gameLayer_ resumeHierarchy];    
}

- (void) notificationPause
{
    [gameLayer_ pauseHierarchy];
}

- (void) notificationResume
{
    [gameLayer_ resumeHierarchy];
}

#pragma mark - Reset Methods

- (void) resetCounters
{
    [Turtling resetID];
    [UFO resetID];
    [Shell resetID];
    [Fuel resetID];
    [Cat resetID];
    [Alien resetID];
    [AlienHoverTurtle resetID];
    [Angel resetID];
    [Boost resetID];
    [BossTurtle resetID];
    [Egg resetID];
    [Flybot resetID];
    [FlyingRock resetID];
    [HoverTurtle resetID];
    [PlasmaBall resetID];
    [ShockTurtling resetID];
    [YellowBird resetID];
    [DummyBoss resetID];
}

@end
