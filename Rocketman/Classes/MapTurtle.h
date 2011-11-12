//
//  MapTurtle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "MapTurtleDelegate.h"

@interface MapTurtle : CCNode {
    
    id <MapTurtleDelegate> delegate_;
    
}

@property (nonatomic, assign) id <MapTurtleDelegate> delegate;

+ (id) mapTurtle:(CGPoint)pos speed:(CGFloat)speed side:(MapTurtleSide)side type:(MapTurtleStyle)type;

- (id) initMapTurtle:(CGPoint)pos speed:(CGFloat)speed side:(MapTurtleSide)side type:(MapTurtleStyle)type;

@end
