//
//  Cat.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Cat : Obstacle {

	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;             
 
    CCAction *collectAnimation_;
    
}

+ (id) catWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

- (void) showCollect;

- (void) destroy;

@end
