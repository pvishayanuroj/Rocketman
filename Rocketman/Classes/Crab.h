//
//  Crab.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"

@interface Crab : Obstacle <BoundaryDelegate> {
    
}

+ (id) crabWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
