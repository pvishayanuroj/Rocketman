//
//  Gauge.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Gauge.h"

@implementation Gauge

/* Minimum time to wait between gauge changes */
const CGFloat GA_MIN_CHANGE_INTERVAL = 0.15f;

+ (id) gauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals cutoffs:(NSArray *)cutoffs
{
    return [[[self alloc] initGauge:gaugeName numIntervals:numIntervals cutoffs:cutoffs] autorelease];
}

- (id) initGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals cutoffs:(NSArray *)cutoffs
{
    if ((self = [super init])) {
    
        lastUpdateTime_ = 0;
        currentInterval_ = 0;
        targetInterval_ = 0;
        useInputTick_ = YES;
        
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
    NSMutableArray *sprites = [NSMutableArray arrayWithCapacity:numIntervals];
    
    for (int i = 0; i < numIntervals; i++) {
        NSString *filename = [NSString stringWithFormat:@"%@ L%d.png", gaugeName, i];
        [sprites addObject:[CCSprite spriteWithSpriteFrameName:filename]];
    }
    
    return sprites;
}

- (void) tick:(CGFloat)value
{
    if (useInputTick_) {
        if (value < minMax_.x || value >= minMax_.y) {
            NSInteger interval = [self getInterval:value];
            targetInterval_ = [self getInterval:value];
            minMax_ = [self getHighLowForInterval:interval];
        }
    }
    [self updateGauge];    
}

- (void) updateGauge
{
    if (currentInterval_ != targetInterval_) {
        
        if (CACurrentMediaTime() - lastUpdateTime_ > GA_MIN_CHANGE_INTERVAL) {
         
            NSInteger interval;
            if (targetInterval_ > currentInterval_) {
                interval = currentInterval_ + 1;
            }
            else {
                interval = currentInterval_ - 1;                
            }
            
            [sprite_ removeFromParentAndCleanup:YES];
            [sprite_ release];
            
            sprite_ = [[sprites_ objectAtIndex:interval] retain];
            [self addChild:sprite_];
            currentInterval_ = interval;                
            lastUpdateTime_ = CACurrentMediaTime();
        }
    }
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
        
- (void) overrideGauge:(CGFloat)value
{
    useInputTick_ = NO;
    targetInterval_ = [self getInterval:value];
}

@end
