//
//  LoadScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "LoadScene.h"
#import "GameScene.h"

@implementation LoadScene

+ (id) stage:(NSUInteger)levelNum
{
    return [[[self alloc] initStage:levelNum] autorelease];
}

- (id) initStage:(NSUInteger)levelNum 
{
	if ((self = [super init])) {
        
        levelNum_ = levelNum;
        CCActionInterval *delay = [CCDelayTime actionWithDuration:1.2f];
        CCActionInstant *load = [CCCallFunc actionWithTarget:self selector:@selector(load)];
        [self runAction:[CCSequence actions:delay, load, nil]];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) load
{
    CCScene *scene = [GameScene stage:levelNum_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];        
}

@end
