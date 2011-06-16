//
//  UFO.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface UFO : Obstacle {
    
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;     
    
}

+ (id) ufoWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

@end
