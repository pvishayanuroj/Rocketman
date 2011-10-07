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

#import "DataManager.h"

@implementation MapLayer

CGFloat ML_ROCKET_ROTATION = 140.0f;
CGFloat ML_ROCKET_SCALE = 0.9f;
CGFloat ML_START_XPOS = 160.0f;
CGFloat ML_START_YPOS = 40.0f;
CGFloat ML_MENU_XPOS = 280.0f;
CGFloat ML_MENU_YPOS = 40.0f;
CGFloat ML_TITLE_XPOS = 160.0f;
CGFloat ML_TITLE_YPOS = 72.0f;

#pragma mark - Object Lifecycle

+ (id) mapWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;
{
    return [[[self alloc] initWithFile:filename lastUnlocked:lastUnlockedLevel currentLevel:currentLevel] autorelease];
}

- (id) initWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel;
{
	if ((self = [super init])) {
 
        // TEMPORARY
        [[DataManager dataManager] animationLoader:@"sheet01_animations" spriteSheetName:@"sheet01"];
        
        currentLevel_ = currentLevel;
        buttons_ = [[NSMutableArray arrayWithCapacity:10] retain];
        
        // Load coordinates from file
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];     
        levelPositions_ = [[NSArray arrayWithContentsOfFile:path] retain];
        
        // Parse the world map file
        NSUInteger levelNum = 0;
        CGPoint rocketPos;
        for (NSDictionary *level in levelPositions_) {
            CGPoint pos = [UtilFuncs parseCoords:[level objectForKey:@"Point"]];
            if (levelNum == currentLevel) {
                rocketPos = pos;
            }
            BOOL locked = levelNum > lastUnlockedLevel;
            MapButton *mapButton = [MapButton mapButton:levelNum++ locked:locked];
            mapButton.delegate = self;
            mapButton.position = pos;       
            [buttons_ addObject:mapButton];
            [self addChild:mapButton z:-1];
        }   
        
        // Add the rocket
        rocket_ = [[CCSprite spriteWithSpriteFrameName:@"Rocket2 Stuck 02.png"] retain];
        rocket_.position = rocketPos;
        rocket_.rotation = ML_ROCKET_ROTATION;
        rocket_.scale = ML_ROCKET_SCALE;
        [self addChild:rocket_];    
        
        // Add buttons
        startButton_ = [[AnimatedButton buttonWithImage:@"Start Button.png" target:self selector:@selector(startPressed)] retain];
        AnimatedButton *menuButton = [AnimatedButton buttonWithImage:@"Menu Button.png" target:self selector:@selector(menuPressed)];    
        startButton_.position = CGPointMake(ML_START_XPOS, ML_START_YPOS);
        menuButton.position = CGPointMake(ML_MENU_XPOS, ML_MENU_YPOS);
        [self addChild:startButton_];
        [self addChild:menuButton];
        
        // Add level title
        levelTitle_ = [[CCLabelBMFont labelWithString:@"Level 0: Training Ground" fntFile:@"SRSMWhiteFont.fnt"] retain];
        levelTitle_.position = CGPointMake(ML_TITLE_XPOS, ML_TITLE_YPOS);
        levelTitle_.scale = 0.65f;
        [self addChild:levelTitle_];
    }
    return self;    
}

- (void) dealloc
{
    [levelPositions_ release];
    [levelDescs_ release];
    [buttons_ release];
    [rocket_ release];
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

- (void) moveRocketTo:(NSUInteger)levelNum
{
    if (levelNum != currentLevel_) {
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
    NSUInteger numLevels = [levelPositions_ count];
    CGFloat speedModifier = 1.0f - (nodes/(CGFloat)numLevels) * 0.5f;
    
    // Lower to higher level
    if (from < to) {
        for (int i = from; i < to; i++) {
            NSDictionary *level = [levelPositions_ objectAtIndex:i];
            NSDictionary *nextLevel = [levelPositions_ objectAtIndex:(i + 1)];
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
            NSDictionary *level = [levelPositions_ objectAtIndex:(i - 1)];
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
    
}

- (void) menuPressed
{
    
}

#pragma mark - Draw Method

- (void) draw
{
#if DEBUG_SHOWMAPCURVES
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);
    
    for (int i = 0; i < [levelPositions_ count] - 1; i++) {
        NSDictionary *level = [levelPositions_ objectAtIndex:i];
        CGPoint start = [UtilFuncs parseCoords:[level objectForKey:@"Point"]];
        CGPoint c1 = [UtilFuncs parseCoords:[level objectForKey:@"C1"]];
        CGPoint c2 = [UtilFuncs parseCoords:[level objectForKey:@"C2"]];        
        NSDictionary *nextLevel = [levelPositions_ objectAtIndex:(i + 1)];
        CGPoint end = [UtilFuncs parseCoords:[nextLevel objectForKey:@"Point"]];
        ccDrawCircle(start, 3, 360, 64, NO);
        ccDrawCircle(c1, 3, 360, 64, NO);        
        ccDrawCircle(c2, 3, 360, 64, NO);
        ccDrawCubicBezier(start, c1, c2, end, 128);
    } 
#endif
}

@end
