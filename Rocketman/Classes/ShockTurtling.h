//
//  ShockTurtling.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface ShockTurtling : Obstacle {
    
    CCAction *preshockAnimation_;
    
    CCAction *shockAnimation_;
    
}

+ (id) shockTurtlingWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showAttacking;

- (void) doneAttacking;

@end
