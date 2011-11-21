//
//  Gauge.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Gauge.h"

@implementation Gauge

+ (id) gauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals cutoffs:(NSArray *)cutoffs
{
    return [[[self alloc] initGauge:gaugeName numIntervals:numIntervals cutoffs:cutoffs] autorelease];
}

- (id) initGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals cutoffs:(NSArray *)cutoffs
{
    if ((self = [super init])) {
    
        sprites_ = [[self loadSprites:gaugeName numIntervals:numIntervals] retain];
        sprite_ = [[sprites_ objectAtIndex:0] retain];
        [self addChild:sprite_];
        
        cutoffs_ = [cutoffs retain];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [sprites_ release];
    [cutoffs_ release];
    
    [super dealloc];
}

- (NSArray *) loadSprites:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals
{
    NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:10];
    
    for (int i = 0; i < numIntervals; i++) {
        NSString *filename = [NSString stringWithFormat:@"%@ L%d.png", gaugeName, i];
        [sprites addObject:[CCSprite spriteWithSpriteFrameName:filename]];
    }
    
    return sprites;
}

- (void) tick:(CGFloat)value
{
    if (value < minMax_.x || value >= minMax_.y) {
        NSInteger interval = [self getInterval:value];
        minMax_ = [self getHighLowForInterval:interval];
        [self updateGauge:interval];
    }
}

- (void) updateGauge:(NSInteger)interval
{
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    
    sprite_ = [[sprites_ objectAtIndex:interval] retain];
    [self addChild:sprite_];
    currentInterval_ = interval;    
}

- (CGPoint) getHighLowForInterval:(NSInteger)interval
{
    CGFloat low;
    if ((interval - 1) < 0) {
        low = CGFLOAT_MIN;
    }
    else {
        low = [[cutoffs_ objectAtIndex:interval - 1] floatValue];
    }

    CGFloat high;
    if (interval >= [cutoffs_ count]) {
        high = CGFLOAT_MAX;
    }
    else {
        high = [[cutoffs_ objectAtIndex:interval] floatValue];
    }
    
    return CGPointMake(low, high);
}

- (NSInteger) getInterval:(CGFloat)value
{
    NSInteger count = 0;
    
    for (NSNumber *n in cutoffs_) {
        if (value < [n floatValue]) {
            break;
        }
        count++;        
    }

    return count;
}

@end
