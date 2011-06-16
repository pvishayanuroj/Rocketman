//
//  Shell.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Shell : Obstacle {
 
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;             
    
}

+ (id) shellWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

@end
