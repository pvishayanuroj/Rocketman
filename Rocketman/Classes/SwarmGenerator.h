//
//  SwarmGenerator.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"

@class GameLayer;

@interface SwarmGenerator : Obstacle {
    
}

+ (void) addHorizontalSwarm:(NSUInteger)size gameLayer:(GameLayer *)gameLayer type:(ObstacleType)type;

+ (void) addVerticalSwarm:(NSUInteger)size gameLayer:(GameLayer *)gameLayer type:(ObstacleType)type;

@end
