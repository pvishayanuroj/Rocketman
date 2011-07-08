//
//  Fuel.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Fuel : Obstacle {
    
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;              
    
    CCAction *collectAnimation_;    
    
}

+ (id) fuelWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

- (void) showCollect;

- (void) destroy;

@end
