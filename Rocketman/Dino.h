//
//  Dino.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Dino : Obstacle {
    
    CCAction *idleAnimation_;
    
    CCAction *flameAnimation_;
    
}

+ (id) dinoWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

- (void) showAttacking;

- (void) addCloud;

- (void) addBlast;

- (void) addText:(id)node data:(void *)data;

@end
