//
//  MapLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapLayer.h"
#import "CatMapButton.h"
#import "GameStateManager.h"
#import "UtilFuncs.h"

@implementation MapLayer

@synthesize selectedButton = selectedButton_;

+ (id) mapWithFile:(NSString *)filename
{
    return [[[self alloc] initWithFile:filename] autorelease];
}

- (id) initWithFile:(NSString *)filename
{
	if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        mapState_ = kStateNeutral;
        selectedButton_ = nil;
        
        // Get the last unlocked levels
        NSUInteger lastUnlockedLevel = [[GameStateManager gameStateManager] lastUnlockedLevel];
        
        // Load coordinates from file
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];     
        NSArray *levels = [NSArray arrayWithContentsOfFile:path];
        
        // Store titles and level descriptions
        levelTitles_ = [[NSMutableArray arrayWithCapacity:[levels count]] retain];        
        levelDescs_ = [[NSMutableArray arrayWithCapacity:[levels count]] retain];
        
        NSUInteger levelNum = 0;
        for (NSDictionary *level in levels) {
            NSString *coord = [level objectForKey:@"MapCoord"];
            NSString *title = [level objectForKey:@"Title"];
            NSString *desc = [level objectForKey:@"Desc"];
            
            [levelTitles_ addObject:title];
            [levelDescs_ addObject:desc];
            
            CGPoint pos = [UtilFuncs parseCoords:coord];
            
            CatMapButton *button;
            if (levelNum < lastUnlockedLevel) {
                button = [CatMapButton activeButtonAt:pos levelNum:levelNum++];
            }
            else {
                button = [CatMapButton inactiveButtonAt:pos levelNum:levelNum++];
            }
            button.delegate = self;
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
    
    [super dealloc];
}

- (void) catButtonPressed:(CatMapButton *)button
{
    switch (mapState_) {
        case kStateNeutral:
            self.selectedButton = button;
            [button selectSpin];
            mapState_ = kStateSelected;
            break;
        case kStateSelected:
            if (button.levelNum != selectedButton_.levelNum) {
                [selectedButton_ stopSpin];
                [button selectSpin];
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
    [[GameStateManager gameStateManager] startGame];
}

- (void) showLevelInfo:(NSUInteger)levelNum
{
    
}

@end
