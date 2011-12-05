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
        
        enemiesKilled_ = [[NSMutableDictionary dictionaryWithCapacity:20] retain];
        
        // Zero all stats
        score_.elapsedTime = 0;
        score_.totalHeight = 0;
        score_.totalSlowTime = 0;
        score_.maxCombo = 0;
        score_.numBombsCollected = 0;
        score_.numBombsFired = 0;
        score_.numBoostCombos = 0;
        score_.numBoostsUsed = 0;
        score_.numCatsCollected = 0;
        score_.numCatsFired = 0;
        score_.numCollisions = 0;
        score_.numEnemiesKilled = 0;
        score_.numFuelCollected = 0;
        score_.numSupercatCombos = 0;
        
        // For tutorials, stop game timer is called before start is called
        startTime_ = CACurrentMediaTime();
    }
    return self;
}

- (void) dealloc
{
    [enemiesKilled_ release];
    
    [super dealloc];
}

- (SRSMScore) score
{
    // Count the total number of enemies killed
    for (NSNumber *key in enemiesKilled_) {
        NSNumber *val = [enemiesKilled_ objectForKey:key];
        score_.numEnemiesKilled += [val integerValue];
    }
    
    return score_;
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

- (void) incrementRocketCollisions
{
    score_.numCollisions++;
}

- (void) incrementBoostsUsed
{
    score_.numBoostsUsed++;
}

- (void) incrementCollectedPowerup:(ObstacleType)type
{
    switch (type) {
        case kBoost:
            score_.numBoostsCollected++;
            break;
        case kFuel:
            score_.numFuelCollected++;
            break;
        case kCat:
            score_.numCatsCollected++;
            break;
        case kBombCat:
            score_.numBombsCollected;
            break;
        case kCatBundle:
            score_.numCatBundlesCollected;
            break;
        default:
            break;
    }
}

- (void) incrementFiredCat:(CatType)type
{
    switch (type) {
        kCatNormal:
            score_.numCatsFired++;
            break;
        kCatBomb:
            score_.numBombsFired++;
            break;
        kCatSuper:
            score_.numSupercatCombos++;
            break;
        default:
            break;
    }
}

- (void) incrementSlowTime:(CGFloat)time
{
    score_.totalSlowTime += time;
}

- (void) setHeight:(CGFloat)height
{
    score_.totalHeight = height;
}

- (void) comboCountUpdated:(NSInteger)count
{
    if (count > score_.maxCombo) {
        score_.maxCombo = count;
    }
}

- (void) startGameTimer
{
    startTime_ = CACurrentMediaTime();
}

- (void) stopGameTimer
{
    score_.elapsedTime += (CACurrentMediaTime() - startTime_);
}

@end
