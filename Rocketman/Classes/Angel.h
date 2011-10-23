//
//  Angel.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Angel : Obstacle <BoundaryDelegate> {
 
    CCAction *slapAnimation_;
    
}

+ (id) angelWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;    

- (void) initActions;

- (void) showAttacking;

+ (void) resetID;

@end
