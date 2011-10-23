//
//  Turtling.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Turtling : Obstacle <BoundaryDelegate> {
    
}

+ (id) turtlingWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

+ (void) resetID;

@end
