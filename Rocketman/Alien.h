//
//  Alien.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Alien : Obstacle {
    
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;         
    
    CCAction *destroyAnimation_;         
    
    //CCSprite *blast_;
    
    //CCSprite *blastCloud_;
    
}

+ (id) alienWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showIdle;

- (void) showDestroy;

- (void) addCloud;

- (void) addBlast;

- (void) addText;

@end
