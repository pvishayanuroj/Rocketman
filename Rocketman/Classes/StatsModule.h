//
//  StatsModule.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface StatsModule : NSObject {
 
    double startTime_;
    
    NSMutableDictionary *enemiesKilled_;
    
    SRSMScore score_;
    
}

@property (nonatomic, readonly) SRSMScore score;

+ (id) statsModule;

- (id) initStatsModule;

- (void) enemyKilled:(ObstacleType)obstacleType;

- (void) incrementRocketCollisions;

- (void) incrementBoostsUsed;

- (void) incrementCollectedPowerup:(ObstacleType)type;

- (void) incrementFiredCat:(CatType)type;

- (void) incrementSlowTime:(CGFloat)time;

- (void) setHeight:(CGFloat)height;

- (void) comboCountUpdated:(NSInteger)count;

- (void) startGameTimer;

- (void) stopGameTimer;

@end
