//
//  WallModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "WallModule.h"
#import "GameManager.h"
#import "Wall.h"

@implementation WallModule

const CGFloat WM_YOFFSET = 480.0f;
const CGFloat WM_XOFFSET = 45.0f;
// How many tiles ahead to place a wall
const NSInteger WM_BUFFER = 2;

+ (id) wallModule:(NSString *)wallName
{
    return [[[self alloc] initWallModule:wallName] autorelease];
}

- (id) initWallModule:(NSString *)wallName
{
    if ((self = [super init])) {
        
        nextHeight_ = -(WM_YOFFSET * WM_BUFFER);
        wallName_ = [wallName retain];
        [self placeWall:0];
        
        lastWall_ = nil;
        
    }
    return self;
}

- (void) dealloc
{
    [wallName_ release];
    [lastWall_ release];
    
    [super dealloc];
}

- (void) heightUpdate:(CGFloat)height
{
    if (height > nextHeight_) {
        [self placeWall:lastWall_.position.y + WM_YOFFSET];        
        nextHeight_ += WM_YOFFSET;
        [self heightUpdate:height];
    }
}

- (void) placeWall:(CGFloat)y
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint p1 = CGPointMake(0, y);
    CGPoint p2 = CGPointMake(size.width - WM_XOFFSET, y);    
    
    NSString *name = [NSString stringWithFormat:@"%@ %02d.png", wallName_, 1];
    Wall *leftWall = [Wall wallWithPos:p1 wallName:name side:kWallLeft];
    [[GameManager gameManager] addDoodad:leftWall];
    
    Wall *rightWall = [Wall wallWithPos:p2 wallName:name side:kWallRight];
    [[GameManager gameManager] addDoodad:rightWall];  
    
    [lastWall_ release];
    lastWall_ = [leftWall retain];
}

@end
