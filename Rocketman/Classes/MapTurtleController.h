//
//  MapTurtleController.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "MapTurtleDelegate.h"

@interface MapTurtleController : CCNode <MapTurtleDelegate> {
    
    CGFloat yPos_;
    
    NSInteger numTurtlesActive_;
    
    NSInteger numTurtlesReturned_;
    
    NSInteger maxNumTurtles_;
    
    MapTurtleStyle turtleStyle_;
    
}

+ (id) mapTurtleController:(NSInteger)numTurtles yPos:(CGFloat)yPos turtleStyle:(MapTurtleStyle)turtleStyle;

- (id) initMapTurtleController:(NSInteger)numTurtles yPos:(CGFloat)yPos turtleStyle:(MapTurtleStyle)turtleStyle;

- (void) randomizeNextGroupTiming;

- (void) addTurtleGroup;

@end
