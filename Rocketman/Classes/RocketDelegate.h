//
//  RocketDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class Obstacle;

@protocol RocketDelegate <NSObject>

- (void) victoryBoostComplete;

- (void) losingFallComplete;

@end