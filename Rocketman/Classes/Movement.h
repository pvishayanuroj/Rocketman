//
//  Movement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class Obstacle;

@interface Movement : NSObject {
    
    Obstacle *obstacle_;
    
}

- (id) initWithObstacle:(Obstacle *)obstacle;

- (void) move:(CGFloat)speed;

@end
