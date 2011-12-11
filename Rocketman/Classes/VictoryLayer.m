//
//  VictoryLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 12/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "VictoryLayer.h"
#import "GameStateManager.h"

@implementation VictoryLayer

@synthesize clickable = clickable_;

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        clickable_ = NO;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - Touch Handlers

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:5 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return clickable_;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [[GameStateManager gameStateManager] continueFromVictory];
}

@end
