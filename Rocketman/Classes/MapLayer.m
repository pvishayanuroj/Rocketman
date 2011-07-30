//
//  MapLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapLayer.h"
#import "CatMapButton.h"
#import "MapText.h"
#import "GameStateManager.h"
#import "UtilFuncs.h"

@implementation MapLayer

@synthesize selectedButton = selectedButton_;

+ (id) mapWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel;
{
    return [[[self alloc] initWithFile:filename lastUnlocked:lastUnlockedLevel] autorelease];
}

- (id) initWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel;
{
	if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        mapState_ = kStateNeutral;
        selectedButton_ = nil;
        
        // Information screen
        mapText_ = [[MapText mapTextWithPos:ccp(160, 560)] retain];
        mapText_.delegate = self;
        mapTextDown_ = NO;
        mapTextSwitch_ = NO;
        inputLocked_ = NO;
        [self addChild:mapText_];
        
        // Load coordinates from file
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];     
        NSArray *levels = [NSArray arrayWithContentsOfFile:path];
        
        // Store titles and level descriptions
        levelTitles_ = [[NSMutableArray arrayWithCapacity:[levels count]] retain];        
        levelDescs_ = [[NSMutableArray arrayWithCapacity:[levels count]] retain];
        buttons_ = [[NSMutableArray arrayWithCapacity:[levels count]] retain];
        
        // Parse the world map file
        NSUInteger levelNum = 0;
        for (NSDictionary *level in levels) {
            NSString *coord = [level objectForKey:@"MapCoord"];
            NSString *title = [level objectForKey:@"Title"];
            NSString *desc = [level objectForKey:@"Desc"];
            
            [levelTitles_ addObject:title];
            [levelDescs_ addObject:desc];
            
            CGPoint pos = [UtilFuncs parseCoords:coord];
            CatMapButton *button;
            
            // Place the cat buttons            
            if (levelNum < lastUnlockedLevel) {
                button = [CatMapButton activeButtonAt:pos levelNum:levelNum];
                if (levelNum == lastUnlockedLevel - 1) {
                    [button setToPulse];
                }
            }
            else {
                button = [CatMapButton inactiveButtonAt:pos levelNum:levelNum];
            }
            levelNum++;
            button.delegate = self;
            [buttons_ addObject:button];
            [self addChild:button];
        }   
    }
    return self;    
}

- (void) dealloc
{
    [selectedButton_ release];
    [levelTitles_ release];
    [levelDescs_ release];
    [buttons_ release];
    [mapText_ release];
    
    [super dealloc];
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!inputLocked_) {
        return YES;
    }
    return NO;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self hideLevelInfo];
    mapState_ = kStateNeutral;
}

- (void) catButtonPressed:(CatMapButton *)button
{
    switch (mapState_) {
        case kStateNeutral:
            self.selectedButton = button;
            [button selectSpin];
            [self showLevelInfo:button.levelNum];            
            mapState_ = kStateSelected;
            break;
        case kStateSelected:
            if (button.levelNum != selectedButton_.levelNum) {
                [selectedButton_ stopSpin];
                [button selectSpin];
                [self showLevelInfo:button.levelNum];
                self.selectedButton = button;
            }
            else {
                [selectedButton_ disappearSpin];
                self.isTouchEnabled = NO;
            }
            break;
        default:
            break;
    }
}

- (void) catButtonSpinComplete:(CatMapButton *)button
{
    // Important: +1 because in the map we use zero-indexing for easier array access,
    // but game stage files use one-indexing
    [[GameStateManager gameStateManager] stageSelectedFromMap:button.levelNum + 1];
}

- (void) showLevelInfo:(NSUInteger)levelNum
{
    [self lockInput];
    
    // If text is already down, move the old one up
    if (mapTextDown_) {
        [mapText_ moveUp];
        mapTextSwitch_ = YES;
    }
    // No text is down, so just move it down
    else {
        [mapText_ setTitle:[levelTitles_ objectAtIndex:levelNum]];
        [mapText_ setDesc:[levelDescs_ objectAtIndex:levelNum]];        
        [mapText_ moveDown];
        mapTextDown_ = YES;
    }
}   

- (void) hideLevelInfo
{
    if (mapTextDown_) {
        [self lockInput];        
        [mapText_ moveUp];
        [selectedButton_ stopSpin];
    }
}

- (void) mapTextMovedDown:(MapText *)mapText
{
    // New text came down without needing to replace an existing text 
    [self unlockInput];
    mapTextDown_ = YES;
}

- (void) mapTextMovedUp:(MapText *)mapText
{
    // In the process of removing old text and showing new text    
    if (mapTextSwitch_) {
        [mapText_ setTitle:[levelTitles_ objectAtIndex:selectedButton_.levelNum]];
        [mapText_ setDesc:[levelDescs_ objectAtIndex:selectedButton_.levelNum]];        
        [mapText_ moveDown];
        mapTextSwitch_ = NO;
    }    
    // Otherwise just removing old text, do not need to show any new text
    else {
        mapTextDown_ = NO;
        [self unlockInput];
    }
}

- (void) lockInput
{
    inputLocked_ = YES;
    for (CatMapButton *b in buttons_) {
        [b lock];
    }    
}

- (void) unlockInput
{
    inputLocked_ = NO;    
    for (CatMapButton *b in buttons_) {
        [b unlock];
    }
}

@end
