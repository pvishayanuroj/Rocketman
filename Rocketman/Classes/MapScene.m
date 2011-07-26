//
//  MapScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapScene.h"
#import "MapLayer.h"

@implementation MapScene

- (id) init 
{
	if ((self = [super init])) {
        
        CCSprite *mapImage = [CCSprite spriteWithFile:@"world_map.png"];
        mapImage.anchorPoint = CGPointZero;        
        [self addChild:mapImage];
        
        MapLayer *mapLayer = [MapLayer mapWithFile:@"WorldMap"];
		[self addChild:mapLayer];        
        
    }
    return self;    
}

- (void) dealloc
{
    [super dealloc];
}

@end