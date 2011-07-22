//
//  Turtling.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface Turtling : Obstacle {
    
}

+ (id) turtlingWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

@end
