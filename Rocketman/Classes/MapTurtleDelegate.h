//
//  MapTurtleDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

@class MapTurtle;

@protocol MapTurtleDelegate <NSObject>

- (void) mapTurtleDoneMoving:(MapTurtle *)mapTurtle;

@end
