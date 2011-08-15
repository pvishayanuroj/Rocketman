//
//  StaticMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Movement.h"

@interface StaticMovement : Movement {
    
}

+ (id) staticMovement:(Obstacle *)obstacle;

- (id) initStaticMovement:(Obstacle *)obstacle;

- (void) move:(CGFloat)speed;

@end
