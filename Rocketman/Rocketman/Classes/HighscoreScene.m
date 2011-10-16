//
//  HighscoreScene.m
//  Rocketman
//
//  Created by Jamorn Ho on 6/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HighscoreScene.h"
#import "HighscoreLayer.h"

@implementation HighscoreScene

- (id) init 
{
	if ((self = [super init])) {
        
        HighscoreLayer *highscoreLayer = [HighscoreLayer node];
		[self addChild:highscoreLayer z:0];

    }
	return self;
}

@end
