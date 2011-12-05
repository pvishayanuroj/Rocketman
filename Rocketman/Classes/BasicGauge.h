//
//  BasicGauge.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 12/4/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface BasicGauge : CCNode {
    
    /** Sprites for each interval */
    NSArray *sprites_;    
    
    /** Current sprite */
    CCSprite *sprite_;
    
}

+ (id) basicGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals;

- (id) initBasicGauge:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals;

- (NSArray *) loadSprites:(NSString *)gaugeName numIntervals:(NSInteger)numIntervals;

- (void) setGauge:(NSInteger)interval;

@end
