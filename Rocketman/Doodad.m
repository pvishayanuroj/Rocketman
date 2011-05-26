//
//  Doodad.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Doodad.h"

@implementation Doodad

- (id) init
{
    if ((self = [super init])) {
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed);
    self.position = ccpSub(self.position, p);    
}

@end
