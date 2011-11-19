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
    
    double accumulatedTime_;
    
    NSMutableDictionary *enemiesKilled_;
    
}

+ (id) statsModule;

- (id) initStatsModule;

- (void) enemyKilled:(ObstacleType)obstacleType;

- (void) startTimer;

- (void) stopTimer;

@end
