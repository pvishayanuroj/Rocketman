//
//  GameObject.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

@synthesize movements = movements_;

+ (id) gameObject
{
    return [[[self alloc] initGameObject] autorelease];
}

- (id) initGameObject
{
    if ((self = [super init])) {
        
        movements_ = [[NSMutableArray arrayWithCapacity:1] retain];                    
        
    }
    return self;
}

- (void) dealloc
{
    [movements_ release];
    
    [super dealloc];
}

@end
