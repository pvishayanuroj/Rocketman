//
//  Fuel.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Fuel : Obstacle <BoundaryDelegate> {

    CCAction *collectAnimation_;    
    
}

+ (id) fuelWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showCollect;

+ (void) resetID;

@end
