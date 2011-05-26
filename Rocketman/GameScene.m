//
//  GameScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"

@implementation GameScene

- (id) init 
{
	if ((self = [super init])) {
		
        GameLayer *gameLayer = [GameLayer node];
		[self addChild:gameLayer];
        
    }
	return self;
}


@end
