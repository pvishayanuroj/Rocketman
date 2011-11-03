//
//  Bat.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"

@interface Bat : Obstacle <BoundaryDelegate> {
    
    ObstacleType origType_;
    
}

+ (id) batWithPos:(CGPoint)pos;

+ (id) swarmBatWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos type:(ObstacleType)type;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
