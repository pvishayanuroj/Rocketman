//
//  Doodad.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Doodad.h"
#import "Movement.h"

@implementation Doodad

@synthesize zDepth = zDepth_;
@synthesize destroyed = destroyed_;

- (id) init
{
    if ((self = [super initGameObject])) {
        
        zDepth_ = kDoodadDepth;
        destroyed_ = NO;
        
    }
    return self;
}

- (void) dealloc
{   
    [super dealloc];
}

- (void) fall:(CGFloat)speed
{
    for (Movement *movement in movements_) {
        [movement move:speed object:self];
    }        
}

@end
