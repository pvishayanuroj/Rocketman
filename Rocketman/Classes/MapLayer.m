//
//  MapLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapLayer.h"
#import "MapButton.h"
#import "LockedText.h"
#import "GameStateManager.h"
#import "UtilFuncs.h"
#import "Pair.h"
#import "AnimatedButton.h"
#import "MapTurtleController.h"

#import "DataManager.h"

@implementation MapLayer

static const CGFloat ML_ROCKET_ROTATION = 140.0f;
static const CGFloat ML_ROCKET_ROTATION2 = 170.0f;
static const CGFloat ML_ROCKET_ROTATION_SPEED = 0.15f;
static const CGFloat ML_ROCKET_ROTATION_DELAY = 0.35f;
static const CGFloat ML_ROCKET_SCALE = 0.9f;
static const CGFloat ML_ROCKET_SCALE_BIG = 1.0f;
static const CGFloat ML_START_XPOS = 160.0f;
static const CGFloat ML_START_YPOS = 40.0f;
static const CGFloat ML_MENU_XPOS = 280.0f;
static const CGFloat ML_MENU_YPOS = 40.0f;
static const CGFloat ML_TITLE_XPOS = 160.0f;
static const CGFloat ML_TITLE_YPOS = 72.0f;
static const CGFloat ML_TURTLE_LINE1_Y = 440.0f;
static const CGFloat ML_TURTLE_LINE2_Y = 360.0f;

#pragma mark - Object Lifecycle

+ (id) map:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;
{
    return [[[self alloc] initMap:lastUnlockedLevel currentLevel:currentLevel] autorelease];
}

- (id) initMap:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;
{
	if ((self = [super init])) {
        
        // Get the map data
        mapData_ = [[[DataManager dataManager] mapData] retain];
        
        currentLevel_ = currentLevel;
        buttons_ = [[NSMutableArray arrayWithCapacity:[mapData_ count]] retain];
        levelDescs_ = [[NSMutableArray arrayWithCapacity:[mapData_ count]] retain];
        
        // Parse the world map file
        NSUInteger levelNum = 0;
        CGPoint rocketPos;
        for (NSDictionary *level in mapData_) {
            
            // Get coordinates of where to place cutouts
            CGPoint pos = [UtilFuncs parseCoords:[level objectForKey:@"Point"]];
            if (levelNum == currentLevel) {
                rocketPos = pos;
            }
            
            // Create the cutout
#if DEBUG_ALLSTAGES
            BOOL locked = NO;
#else
            BOOL locked = levelNum > lastUnlockedLevel;
#endif
            MapButton *mapButton = [MapButton mapButton:levelNum locked:locked];
            mapButton.delegate = self;
            mapButton.position = pos;       
            [buttons_ addObject:mapButton];
            [self addChild:mapButton z:-1];
            
            // Store the level names
            NSString *levelName = [NSString stringWithFormat:@"Level %d: %@", levelNum, [level objectForKey:@"Name"]];
            [levelDescs_ addObject:levelName];
            
            levelNum++;
        }   
        
        // Add the rocket
        rocket_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket2 Stuck 02.png"] retain];
        rocket_.position = rocketPos;
        rocket_.rotation = ML_ROCKET_ROTATION;
        rocket_.scale = ML_ROCKET_SCALE;
        [self addChild:rocket_];    
        
        // Add buttons
        startButton_ = [[AnimatedButton buttonWithImage:R_START_TEXT target:self selector:@selector(startPressed)] retain];
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:R_MENU_TEXT target:self selector:@selector(menuPressed)];    
        startButton_.position = CGPointMake(ML_START_XPOS, ML_START_YPOS);
        menuButton.position = CGPointMake(ML_MENU_XPOS, ML_MENU_YPOS);
        [self addChild:startButton_];
        [self addChild:menuButton];
        
        // Add level title
        levelTitle_ = [[CCLabelBMFont labelWithString:[levelDescs_ objectAtIndex:currentLevel] fntFile:@"SRSM White Font 28.fnt"] retain];
        levelTitle_.position = CGPointMake(ML_TITLE_XPOS, ML_TITLE_YPOS);
        levelTitle_.scale = 0.65f;
        [self addChild:levelTitle_];
        
        // Add flying map turtles
        NSInteger numTurtlesLine1 = (lastUnlockedLevel > 3) ? 3 : 0;        
        NSInteger numTurtlesLine2 = (lastUnlockedLevel > 3) ? 3 : lastUnlockedLevel;
        [self addChild:[MapTurtleController mapTurtleControllerWithImmediateAdd:numTurtlesLine1 yPos:ML_TURTLE_LINE1_Y turtleStyle:kFadedTurtle]];
        [self addChild:[MapTurtleController mapTurtleController:numTurtlesLine2 yPos:ML_TURTLE_LINE2_Y turtleStyle:kSharpTurtle]];
        
        [self initActions];
        [self animateRocket];
    }
    return self;    
}

- (void) dealloc
{
    [mapData_ release];
    [levelDescs_ release];
    [buttons_ release];
    [rocket_ release];
    [rocketAnimation_ release];
    [startButton_ release];
    [levelTitle_ release];
    
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) mapButtonPressed:(MapButton *)button
{
    if (button.isLocked) {
        LockedText *locked = [LockedText lockedText];
        locked.position = button.position;        
        [self addChild:locked];
    }
    else {
        [self moveRocketTo:button.levelNum];
    }
}

#pragma mark - Object Manipulation Methods

- (void) initActions
{
    /*
    CCActionInterval *rot1 = [CCRotateTo actionWithDuration:ML_ROCKET_ROTATION_SPEED angle:ML_ROCKET_ROTATION2];
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:ML_ROCKET_ROTATION_DELAY];
    CCActionInterval *rot2 = [CCRotateTo actionWithDuration:ML_ROCKET_ROTATION_SPEED angle:ML_ROCKET_ROTATION];    
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:ML_ROCKET_ROTATION_DELAY];
    
    CCAction *rock = [CCRepeatForever actionWithAction:[CCSequence actions:rot1, delay1, rot2, delay2, nil]];
    [rocket_ runAction:rock];
    */
    
    CGFloat duration = 0.05;
    CGFloat delay = 0.3;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:ML_ROCKET_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:ML_ROCKET_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:delay];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:delay];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]];
    rocketAnimation_ = [pulse retain];
}

- (void) animateRocket
{
    [rocket_ stopAllActions];
    [rocket_ runAction:rocketAnimation_];
}

- (void) moveRocketTo:(NSUInteger)levelNum
{
    if (levelNum != currentLevel_) {
        [rocket_ stopAllActions];
        [self lockInput];           
        [self hideStart];
        CCActionInterval *move = [self constructMoveFrom:currentLevel_ to:levelNum];     
        [rocket_ runAction:move];
        currentLevel_ = levelNum;          
    }
}

- (CCActionInterval *) constructMoveFrom:(NSUInteger)from to:(NSUInteger)to
{   
    NSMutableArray *actionArray = [NSMutableArray arrayWithCapacity:5];
    
    NSUInteger nodes = abs(from - to);
    NSUInteger numLevels = [mapData_ count];
    CGFloat speedModifier = 1.0f - (nodes/(CGFloat)numLevels) * 0.5f;
    
    // Lower to higher level
    if (from < to) {
        for (int i = from; i < to; i++) {
            NSDictionary *level = [mapData_ objectAtIndex:i];
            NSDictionary *nextLevel = [mapData_ objectAtIndex:(i + 1)];
            ccBezierConfig bezier;
            bezier.controlPoint_1 = [UtilFuncs parseCoords:[level objectForKey:@"C1"]];
            bezier.controlPoint_2 = [UtilFuncs parseCoords:[level objectForKey:@"C2"]];
            bezier.endPosition = [UtilFuncs parseCoords:[nextLevel objectForKey:@"Point"]];
            NSNumber *time = [level objectForKey:@"Time"];
            CGFloat speed = [time floatValue] * speedModifier;
            [actionArray addObject:[CCBezierTo actionWithDuration:speed bezier:bezier]];
        }

    }
    // Higher to lower level
    else {
        for (int i = from; i > to; i--) {
            NSDictionary *level = [mapData_ objectAtIndex:(i - 1)];
            ccBezierConfig bezier;
            bezier.controlPoint_1 = [UtilFuncs parseCoords:[level objectForKey:@"C2"]];
            bezier.controlPoint_2 = [UtilFuncs parseCoords:[level objectForKey:@"C1"]];
            bezier.endPosition = [UtilFuncs parseCoords:[level objectForKey:@"Point"]];
            NSNumber *time = [level objectForKey:@"Time"];   
            CGFloat speed = [time floatValue] * speedModifier;
            [actionArray addObject:[CCBezierTo actionWithDuration:speed bezier:bezier]];
        }            
    }
    
    [actionArray addObject:[CCCallFunc actionWithTarget:self selector:@selector(doneMoving)]];
    CCActionInterval *actions = [CCSequence actionsWithArray:actionArray];
    return actions;
}

- (void) doneMoving
{
    [self unlockInput];
    [self showStart];
    [self animateRocket];
    
    [levelTitle_ setString:[levelDescs_ objectAtIndex:currentLevel_]];
}

- (void) hideStart
{
    startButton_.visible = NO;
    startButton_.isLocked = YES;
}

- (void) showStart
{
    startButton_.visible = YES;
    startButton_.isLocked = NO;
}

- (void) lockInput
{
    for (MapButton *button in buttons_) {
        button.isClickable = YES;
    }
}

- (void) unlockInput
{
    for (MapButton *button in buttons_) {
        button.isClickable = NO;
    }
}

#pragma mark - State Change Handlers

- (void) startPressed
{
    [[GameStateManager gameStateManager] stageSelectedFromMap:currentLevel_];
}

- (void) menuPressed
{
    [[GameStateManager gameStateManager] menuFromMap];
}

#pragma mark - Draw Method

- (void) draw
{
#if DEBUG_SHOWMAPCURVES
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);
    
    for (int i = 0; i < [mapData_ count] - 1; i++) {
        NSDictionary *level = [mapData_ objectAtIndex:i];
        CGPoint start = [UtilFuncs parseCoords:[level objectForKey:@"Point"]];
        CGPoint c1 = [UtilFuncs parseCoords:[level objectForKey:@"C1"]];
        CGPoint c2 = [UtilFuncs parseCoords:[level objectForKey:@"C2"]];        
        NSDictionary *nextLevel = [mapData_ objectAtIndex:(i + 1)];
        CGPoint end = [UtilFuncs parseCoords:[nextLevel objectForKey:@"Point"]];
        ccDrawCircle(start, 3, 360, 64, NO);
        ccDrawCircle(c1, 3, 360, 64, NO);        
        ccDrawCircle(c2, 3, 360, 64, NO);
        ccDrawCubicBezier(start, c1, c2, end, 128);
    } 
#endif
}

@end
