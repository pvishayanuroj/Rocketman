//
//  BasicGauge.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 12/4/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BasicGauge.h"


@implementation BasicGauge

+ (id) basicGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals
{
    return [[[self alloc] initBasicGauge:gaugeName numIntervals:numIntervals] autorelease];
}

- (id) initBasicGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals
{
    if ((self = [super init])) {

        sprites_ = [[self loadSprites:gaugeName numIntervals:numIntervals] retain];
        sprite_ = [[sprites_ objectAtIndex:0] retain];
        [self addChild:sprite_];        
    }
    return self;
}

- (void) dealloc
{
    [sprites_ release];
    [sprite_ release];
    
    [super dealloc];
}

- (NSArray *) loadSprites:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals
{
    NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:numIntervals];
    
    for (int i = 0; i < numIntervals; i++) {
        NSString *filename = [NSString stringWithFormat:@"%@ L%d.png", gaugeName, i];
        [sprites addObject:[CCSprite spriteWithSpriteFrameName:filename]];
    }
    
    return sprites;
}

- (void) setGauge:(NSInteger)interval
{
    // Boundary checking
    NSInteger idx = interval;
    if (interval < 0) {
        idx = 0;
    }
    else if (interval >= [sprites_ count]) {
        idx = [sprites_ count] - 1;
    }
    
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    
    sprite_ = [[sprites_ objectAtIndex:idx] retain];
    [self addChild:sprite_];    
}

@end
