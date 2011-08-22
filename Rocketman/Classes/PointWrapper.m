//
//  PointWrapper.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PointWrapper.h"


@implementation PointWrapper

@synthesize point = point_;

+ (id) cgPoint:(CGPoint)p
{
    return [[[self alloc] initCGPoint:p] autorelease];
}

- (id) initCGPoint:(CGPoint)p
{
    if ((self = [super init])) {
        
        point_ = p;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Point (%6.2f, %6.2f)", point_.x, point_.y];
}    

@end
