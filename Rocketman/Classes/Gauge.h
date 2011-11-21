//
//  Gauge.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface Gauge : CCNode {
    
    /** Sprites for each interval */
    NSArray *sprites_;    
    
    /** Current sprite */
    CCSprite *sprite_;
    
    /** Min and max values for the current interval, x for min, y for max */
    CGPoint minMax_;
    
    /** Current intervals, there are always N cutoffs and N+1 intervals */
    NSInteger currentInterval_;
    
    /** Threshold values, there are always N cutoffs and N+1 intervals */
    NSArray *cutoffs_;
    
}

+ (id) gauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals cutoffs:(NSArray *)cutoffs;

- (id) initGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals cutoffs:(NSArray *)cutoffs;

- (NSArray *) loadSprites:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals;

- (void) tick:(CGFloat)value;

/** Used to update the gauge sprite */
- (void) updateGauge:(NSInteger)interval;

/** Returns the low and high for this interval, where x is low and y is high */
- (CGPoint) getHighLowForInterval:(NSInteger)interval;

/** 
 * Returns the interval which this value is in. All values less than the first
 * cutoff fall under interval 0. All values between the first and second cutoffs
 * are in interval 1. All values greater than the last cutoff are in interval N,
 * where N is the number of cutoffs 
 */
- (NSInteger) getInterval:(CGFloat)value;

@end
