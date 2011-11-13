//
//  WallModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "WallModule.h"


@implementation WallModule

+ (id) wallModule:(NSString *)wallName
{
    return [[[self alloc] initWallModule:wallName] autorelease];
}

- (id) initWallModule:(NSString *)wallName
{
    if ((self = [super init])) {
        
        wallName_ = [wallName retain];
        
    }
    return self;
}

- (void) dealloc
{
    [wallName_ release];
    
    [super dealloc];
}

- (void) heightUpdate:(CGFloat)height
{
    
}

- (void) placeWall
{
    
}

@end
