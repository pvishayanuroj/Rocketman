//
//  ObstacleDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class Obstacle;

@protocol ObstacleDelegate <NSObject>

- (void) obstacleHeightTriggered:(Obstacle *)obstacle;

@end
