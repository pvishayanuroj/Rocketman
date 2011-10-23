//
//  Alien.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Alien : Obstacle <BoundaryDelegate> {
    
}

+ (id) alienWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

+ (void) resetID;

@end
