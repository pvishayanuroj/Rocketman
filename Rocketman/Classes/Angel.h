//
//  Angel.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Angel : Obstacle {
 
    CCAction *idleAnimation_;
    
    CCAction *slapAnimation_;
    
}

+ (id) angelWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;    

- (void) initActions;

- (void) showIdle;

- (void) showAttacking;

@end
