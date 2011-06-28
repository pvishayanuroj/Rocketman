//
//  Dino.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Dino : Obstacle <PrimaryCollisionProtocol, PrimaryHitProtocol> {
    
    CCAction *idleAnimation_;
    
    CCAction *flameAnimation_;
    
    PVCollide primaryPVCollide_;
    
}

+ (id) dinoWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

- (void) showAttacking;

@end
