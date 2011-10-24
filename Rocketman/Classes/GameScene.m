//
//  GameScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "HUDLayer.h"
#import "PauseLayer.h"
#import "DialogueLayer.h"
#import "GameManager.h"
#import "DataManager.h"

@implementation GameScene

+ (id) stage:(NSUInteger)levelNum
{
    return [[[self alloc] initStage:levelNum] autorelease];
}

- (id) initStage:(NSUInteger)levelNum 
{
	if ((self = [super init])) {

        NSDictionary *data = [[DataManager dataManager] getLevelData:levelNum];
        [[GameManager gameManager] initNotifications:levelNum];
        GameLayer *gameLayer = [GameLayer startWithLevelData:data];
		[self addChild:gameLayer z:0];
        
        HUDLayer *hudLayer = [HUDLayer node];
        [self addChild:hudLayer z:1];
        
        [hudLayer addCatButton];
        [hudLayer addBombButton];        
        [hudLayer addSlowButton];
        [hudLayer addBoostButton];
        
        DialogueLayer *dialogueLayer = [DialogueLayer node];
        [self addChild:dialogueLayer z:2];
        
        PauseLayer *pauseLayer = [PauseLayer node];
        [self addChild:pauseLayer z:3];
        
    }
	return self;
}

@end
