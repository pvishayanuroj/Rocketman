//
//  GameLayerDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class Obstacle;

@protocol GameLayerDelegate <NSObject>

- (void) heightUpdate:(NSInteger)height;

- (void) speedUpdate:(CGFloat)speed;

- (void) obstacleAdded:(Obstacle *)obstacle;

@end
