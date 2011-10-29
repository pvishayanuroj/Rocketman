//
//  StaticMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StaticMovement.h"
#import "GameObject.h"

@implementation StaticMovement

+ (id) staticMovement
{
    return [[[self alloc] initStaticMovement:1.0f] autorelease];
}

+ (id) staticMovement:(CGFloat)rate
{
    return [[[self alloc] initStaticMovement:rate] autorelease];    
}

- (id) initStaticMovement:(CGFloat)rate
{
    if ((self = [super initMovement])) {
        
        rate_ = rate;
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    CGPoint p = CGPointMake(0, -speed * rate_);
    object.position = ccpAdd(object.position, p);    
}

@end
