//
//  StatsModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StatsModule.h"

@implementation StatsModule

+ (id) statsModule
{
    return [[[self alloc] initStatsModule] autorelease];
}

- (id) initStatsModule
{
    if ((self = [super init])) {
        
        accumulatedTime_ = 0;
        enemiesKilled_ = [[NSMutableDictionary dictionaryWithCapacity:20] retain];
        
    }
    return self;
}

- (void) dealloc
{
    [enemiesKilled_ release];
    
    [super dealloc];
}

- (void) enemyKilled:(ObstacleType)obstacleType
{
    NSNumber *key = [NSNumber numberWithInt:obstacleType];
    NSNumber *count = [enemiesKilled_ objectForKey:key];
    
    // If exists, increment by 1
    if (count) {
        count = [NSNumber numberWithInt:[count intValue] + 1];
    }
    else { 
        count = [NSNumber numberWithInt:1];
    }
    
    [enemiesKilled_ setObject:count forKey:key];    
}

- (void) startTimer
{
    startTime_ = CACurrentMediaTime();
}

- (void) stopTimer
{
    accumulatedTime_ += (CACurrentMediaTime() - startTime_);
}

@end
