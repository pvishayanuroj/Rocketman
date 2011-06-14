//
//  MainMenuScene.m
//  Rocketman
//
//  Created by Jamorn Ho on 5/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuScene.h"
#import "MainMenuLayer.h"


@implementation MainMenuScene

- (id) init 
{
	if ((self = [super init])) {
		
        MainMenuLayer *mainMenuLayer = [MainMenuLayer node];
		[self addChild:mainMenuLayer];
        
    }
	return self;
}

@end
