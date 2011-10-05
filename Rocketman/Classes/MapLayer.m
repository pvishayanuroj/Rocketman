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

@implementation MapLayer

+ (id) mapWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel;
{
    return [[[self alloc] initWithFile:filename lastUnlocked:lastUnlockedLevel] autorelease];
}

- (id) initWithFile:(NSString *)filename lastUnlocked:(NSUInteger)lastUnlockedLevel;
{
	if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        
        // Load coordinates from file
        NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];     
        NSArray *levels = [NSArray arrayWithContentsOfFile:path];
        
        // Parse the world map file
        NSUInteger levelNum = 0;
        for (NSString *coord in levels) {
            CGPoint pos = [UtilFuncs parseCoords:coord];
            BOOL locked = levelNum > lastUnlockedLevel;
            MapButton *mapButton = [MapButton mapButton:levelNum++ locked:locked];
            mapButton.delegate = self;
            mapButton.position = pos;            
            [self addChild:mapButton];
        }   
    }
    return self;    
}

- (void) dealloc
{
    [levelDescs_ release];
    
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
}

- (void) lockInput
{

}

- (void) unlockInput
{

}

@end
