//
//  Boost.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Boost : Obstacle {
 
}

+ (id) boostWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) destroy;

@end
