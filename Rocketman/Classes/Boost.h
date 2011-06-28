//
//  Boost.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Boost : Obstacle <PrimaryCollisionProtocol> {
 
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;    
    
    PVCollide primaryPVCollide_;
    
}

+ (id) boostWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

- (void) destroy;

@end
