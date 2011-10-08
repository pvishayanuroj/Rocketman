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

CGFloat MS_LINE1_YPOS = 70.0f;
CGFloat MS_LINE2_YPOS = 40.0f;
CGFloat MS_LINE2_XSCALE = 0.7f;

+ (id) mapWithLastUnlocked:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel
{
    return [[[self alloc] initMapWithLastUnlocked:lastUnlockedLevel currentLevel:currentLevel] autorelease];
}

- (id) initMapWithLastUnlocked:(NSUInteger)lastUnlockedLevel currentLevel:(NSUInteger)currentLevel
{
	if ((self = [super init])) {
        
        CCSprite *mapImage = [CCSprite spriteWithFile:@"World Map.png"];
        mapImage.anchorPoint = CGPointZero;        
        [self addChild:mapImage];
        
        CCSprite *line1 = [CCSprite spriteWithFile:@"Black Line.png"];
        line1.anchorPoint = CGPointMake(0.0f, 0.5f);
        line1.position = CGPointMake(0, MS_LINE1_YPOS);
        [self addChild:line1];
        
        CCSprite *line2 = [CCSprite spriteWithFile:@"Black Line.png"];        
        line2.anchorPoint = CGPointMake(0.0f, 0.5f);
        line2.position = CGPointMake(0, MS_LINE2_YPOS);
        line2.scaleX = MS_LINE2_XSCALE;
        [self addChild:line2];        
        
        MapLayer *mapLayer = [MapLayer map:lastUnlockedLevel currentLevel:currentLevel];
		[self addChild:mapLayer];        
    }
    return self;    
}

- (void) dealloc
{
    [super dealloc];
}

@end
