//
//  BlueBird.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"
#import "cocos2d.h"

@interface BlueBird : Obstacle <BoundaryDelegate> {
    
}

+ (id) swarmBlueBirdWithPos:(CGPoint)pos;

+ (id) blueBirdWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
