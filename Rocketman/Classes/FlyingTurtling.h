//
//  FlyingTurtling.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"

@interface FlyingTurtling : Obstacle <BoundaryDelegate> {
    
}

+ (id) flyingTurtlingWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
