//
//  PlasmaBall.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface PlasmaBall : Obstacle <BoundaryDelegate> {
    
}

+ (id) plasmaBallWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

+ (void) resetID;

@end
